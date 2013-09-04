#!/bin/bash
fpm -s python -t rpm awscli
fpm -s python -t rpm six
fpm -s python -t rpm -v 0.16.0 botocore
fpm -s python -t rpm -v 0.9.0 bcdoc
fpm -s python -t rpm -v 0.2.5 colorama
fpm -s python -t rpm argparse
fpm -s python -t rpm docutils
fpm -s python -t rpm -v 3.1.1 rsa
fpm -s python -t rpm -v 1.2.0 requests
fpm -s python -t rpm -v 0.0.2 jmespath
fpm -s python -t rpm -v 1.1 ordereddict
fpm -s python -t rpm -v 3.3.0 simplejson
fpm -s python -t rpm python-dateutil
fpm -s python -t rpm pyasn1
fpm -s python -t rpm -v 3.4 ply

