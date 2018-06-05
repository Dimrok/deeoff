cleanup/ubuntu/16.04:
	@sudo rm -rf /tmp/ubuntu/16.04

cleanup/ubuntu/14.04:
	@sudo rm -rf /tmp/ubuntu/14.04

cleanup/ubuntu:
	@sudo rm -rf /tmp/ubuntu

cleanup/centos/7:
	@sudo rm -rf /tmp/centos/7

cleanup/centos/6:
	@sudo rm -rf /tmp/centos/6

cleanup/centos:
	@sudo rm -rf /tmp/centos

ubuntu/16.04: cleanup/ubuntu/16.04
	@docker run --rm -v "/tmp/ubuntu/16.04:/packages" -v "${PWD}/scripts/ubuntu.sh:/script.sh" -e DOCKER_SUBSCRIPTION= -e DOCKER_VERSION=17.06 ubuntu:16.04 /script.sh
	tar cvzf 16.04.tar.gz /tmp/ubuntu/16.04

ubuntu/14.04: cleanup/ubuntu/14.04
	@docker run --rm -v "/tmp/ubuntu/14.04:/packages" -v "${PWD}/scripts/ubuntu.sh:/script.sh" -e DOCKER_SUBSCRIPTION= -e DOCKER_VERSION=17.06 ubuntu:14.04 /script.sh
	tar cvzf 14.04.tar.gz /tmp/ubuntu/14.04

centos/7: cleanup/centos/7
	@docker run --rm -v "/tmp/centos/7:/packages" -v "${PWD}/scripts/centos.sh:/script.sh" -e DOCKER_SUBSCRIPTION= -e DOCKER_VERSION=17.06 centos:7 /script.sh
	tar cvzf 7.tar.gz /tmp/centos/7

# Not 100% sure.
centos/6: cleanup/centos/6
	@docker run -v "/tmp/centos/6:/var/cache/yum" -v "${PWD}/scripts/centos.sh:/script.sh" -e DOCKER_SUBSCRIPTION= -e DOCKER_VERSION=17.06 centos:6 /script.sh
	tar cvzf 6.tar.gz /tmp/centos/6
