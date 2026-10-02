#!/usr/bin/env python3
"""Snapshot named Objective-C classes declared in the installed public UIKit headers.

Categories, protocols, forward declarations, and Swift-only APIs are not classes
in this inventory. Preserve platform/availability annotations for reference cards.
Run explicitly when upgrading Xcode; normal builds use the checked-in snapshot.
"""
import json
import pathlib
import re
import subprocess

sdk = pathlib.Path(subprocess.check_output(
    ['xcrun', '--sdk', 'iphonesimulator', '--show-sdk-path'], text=True).strip())
headers = sdk / 'System/Library/Frameworks/UIKit.framework/Headers'
classes = {}
for header in sorted(headers.glob('*.h')):
    source = header.read_text()
    source = re.sub(r'/\*.*?\*/|//[^\n]*', '', source, flags=re.S)
    for match in re.finditer(r'@interface\s+(\w+)\s*(?:<[^>]*>\s*)?:\s*(\w+)', source):
        name, superclass = match.groups()
        # A semicolon inside a deprecation message is not a declaration boundary.
        start = 0
        for token in re.finditer(r'"(?:\\.|[^"\\])*"|;|@end', source[:match.start()]):
            if not token.group().startswith('"'):
                start = token.end()
        prefix = source[start:match.start()]
        annotations = []
        for macro in re.finditer(r'(?:API_\w+|NS_\w*(?:AVAILABLE|DEPRECATED)\w*|UIKIT_\w*(?:AVAILABLE|DEPRECATED)\w*)\(', prefix):
            depth = 1
            for token in re.finditer(r'"(?:\\.|[^"\\])*"|[()]', prefix[macro.end():]):
                if token.group() == '(':
                    depth += 1
                elif token.group() == ')':
                    depth -= 1
                if depth == 0:
                    annotations.append(' '.join(prefix[macro.start():macro.end() + token.end()].split()))
                    break
        classes[name] = dict(name=name, superclass=superclass, header=header.name,
                             availability='\n'.join(annotations[-6:]))

def category(name):
    chain = []
    while name in classes and name not in chain:
        chain.append(name)
        name = classes[name]['superclass']
    for ancestor, label in [('UIControl', 'Controls'), ('UIViewController', 'View controllers'),
                            ('UIView', 'Views'), ('UIGestureRecognizer', 'Gestures'),
                            ('UILayoutGuide', 'Layout')]:
        if ancestor in chain:
            return label
    return 'Supporting objects'

for name, entry in classes.items():
    entry['category'] = category(name)
result = dict(sdk=sdk.name, scope='Named Objective-C classes declared in public UIKit headers; includes platform-specific and deprecated declarations.',
              classes=[classes[name] for name in sorted(classes)])
target = pathlib.Path(__file__).resolve().parents[1] / 'UIKitTest/UIKitCatalog.json'
target.write_text(json.dumps(result, indent=2) + '\n')
print(f'Wrote {len(classes)} classes to {target}')
