#!/bin/bash
set -x

IMAGEDIR=$1

cd scripts
curl -O https://raw.githubusercontent.com/DataBiosphere/terra-docker/master/scripts/generate_package_docs.py
curl -O https://raw.githubusercontent.com/DataBiosphere/terra-docker/master/scripts/utils.py

cat << "EOF" > generate_packages.py
from sys import argv
import generate_package_docs
import utils

config_location = "config/conf.json"

def main():
  params = generate_package_docs.ParamProcessor(argv)
  docs = generate_package_docs.get_docs(params)
  file_name = "{}/info/{}-{}".format(params.image_dir, params.image_config['version'], params.config['doc_suffix'])
  utils.write_json_to_file(docs, file_name)

if __name__ == '__main__':
  main()

EOF

cd .. && python scripts/generate_packages.py $IMAGEDIR
