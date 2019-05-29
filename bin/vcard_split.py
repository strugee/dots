#!/usr/bin/env python3

# Split a .vcf file with multiple VCards into multiple .vcfs, one per VCard
# Requires the pythonn3-vobject package on Debian

import os
from pathlib import Path
import vobject

os.mkdir('out', exist_ok=True)

with open('contacts-2019-05-29.vcf') as f:
    for c in vobject.readComponents(f.read()):
         i = 0
         name = str(c.getChildValue('n')).strip().replace('/', '_')
         # Work around a crash; see eventable/vobject#59 on GitHub
         if 'photo' in c.contents:
             del c.contents['photo']
             assert c.validate()
         with Path('out/{name}.vcf'.format(name=name)) as outfile:
             while outfile.exists():
                 i += 1
                 outfile = Path('out/{name} {i}.vcf'.format(name=name, i=str(i)))
             outfile.write_text(c.serialize())
