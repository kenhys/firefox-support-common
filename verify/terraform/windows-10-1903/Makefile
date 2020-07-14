# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

.PHONY: apply ansible destroy

all: apply

apply:
	terraform init
	terraform plan
	time (terraform apply -auto-approve && sleep 10 && ansible-playbook -i ansible/hosts ansible/playbook.yml)

apply-playbook:
	ansible-playbook -i ansible/hosts ansible/playbook.yml

destroy:
	terraform destroy -auto-approve