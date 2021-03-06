# -*- coding: utf-8 -*-
#
# Copyright (c) 2018-2020 by Paweł Tomulik <ptomulik@meil.pw.edu.pl>
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE

__docformat__ = "restructuredText"

"""
TODO: write docs
"""

import sys
import TestSCons
import zipfile

if sys.platform == 'win32':
    test = TestSCons.TestSCons(program='scons.bat', interpreter=None)
else:
    test = TestSCons.TestSCons()

test.subdir(['site_scons'])
test.subdir(['site_scons', 'site_tools'])
test.subdir(['site_scons', 'site_tools', 'archives'])
test.file_fixture('../../../../__init__.py','site_scons/site_tools/archives/__init__.py')
test.file_fixture('../../../../about.py','site_scons/site_tools/archives/about.py')

test.subdir(['src'])

test.write('SConstruct', """\
# SConstruct
import os
env = Environment(tools=['archives'])
env.ZipFile('package.zip', ['foo.txt', 'bar.txt'])
""" % locals())

test.write('foo.txt', """\
foo
""")

test.write('bar.txt', """\
bar
""")

test.run()

test.must_exist('package.zip')

test.fail_test(not zipfile.is_zipfile(test.workpath('package.zip')))
with zipfile.ZipFile(test.workpath('package.zip'), 'r') as f:
    names = f.namelist()
    assert names == ['foo.txt', 'bar.txt']

test.run(['-c'])

test.must_not_exist('package.zip')

test.pass_test()

# Local Variables:
# # tab-width:4
# # indent-tabs-mode:nil
# # End:
# vim: set syntax=python expandtab tabstop=4 shiftwidth=4:
