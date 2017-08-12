# kubernetes-centos7-vagrant

# 목표

* Vagrant 를 이용하여 Master 1대와 Node 3대로된 Kubernetes 클러스터를 구성합니다.
* Master 와 Node 의 OS는 CentOS 7을 사용합니다.
* Kubernetes 의 설치는 kubeadm 을 이용하여 설치합니다.

## 기본 환경 설치

Windows 또는 Mac, Linux 어디든 아래 환경을 설치합니다.


* [VirtualBox - https://www.virtualbox.org/](https://www.virtualbox.org/)
* [Vagrant - https://www.vagrantup.com/](https://www.vagrantup.com/)
    * "환경 설정 -> 네트워크 -> 호스트 전용 네트워크" 에 추가된 어댑터가 없으면 추가하고 DHCP 는 꺼버린다.
* [Vagrant Plugin](https://github.com/dotless-de/vagrant-vbguest) - VM 생성시 VirtualBox Guest Additions 을 자동으로 설치해주는 플러그인 입니다.
    ```bash
    $ vagrant plugin install vagrant-vbguest
    ```
* [Vagrant provision reboot - https://github.com/exratione/vagrant-provision-reboot](https://github.com/exratione/vagrant-provision-reboot)
* [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/) - Vagrant 가 설치된 Windows 또는 Mac, Linux 에 설치합니다.

## Git 을 clone 한다.

```bash
$ git clone https://github.com/zhato/kubernetes-centos7-vagrant.git
$ cd kubernetes-centos7-vagrant
```

## 클러스터 환경 설정

* config.rb 파일에 클러스터가 사용할 IP Address(호스트 전용 네트워크에 등록된 IP) 와 Master/Node 의 메모리 크기와 Node 수를 정의한다.
```bash
# kubeadm init token
$token = "56225f.9096af3559800a6a"

# IpAddress - VirtualBox host only network ip....
$clusterIp = "192.168.56."

# Master
$master_memory = 1536

# node
$node_count = 3
$node_memory = 1536
```

## Kubernetes cluster 생성

```bash
$ cd /path/to/kubernetes-centos7-vagrant
$ vagrant up
```

## Dashboard 확인

Windows 또는 Mac, Linux 에서 아래 명령을 실행하고 http://locahost:8001/ui/ 로 접속한다.

```bash
$ cd /path/to/kubernetes-centos7-vagrant
$ /path/to/kubectl --kubeconfig admin.conf proxy
```

* admin.conf 는 vagranfile 에 정의된 config.vm.synced_folder ".", "/shared" 에 의해서 현재 master 에 kubernetes 가 모두 설치 된 후에 현재 디렉터리로(/shared)로 admin.conf 를 복사한다.

## 기타

* [https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel-rbac.yml](https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel-rbac.yml)
* [https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml](https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml)
    ```bash
        command: [ "/opt/bin/flanneld", "--ip-masq", "--kube-subnet-mgr"] <-- 이걸

        command: [ "/opt/bin/flanneld", "--ip-masq", "--kube-subnet-mgr" , "--iface=eth1"] <-- 이걸로 수정함.

        위와 같이 수정을 안하면 대시보드 접속이 안됩니다.
        eth0는 VirtualBox 의 기본이 NAT로 동작해서 서비스 네트웍으로 구축이 안되서 통신이 안됩니다.
        eth1은 host only 로 된 Interface라 이것이 지정되어야 모든 통신이 정상적으로 동작합니다.
    ```

## 참조 링크

* [Using kubeadm to Create a Cluster - https://kubernetes.io/docs/setup/independent/create-cluster-kubeadm/](https://kubernetes.io/docs/setup/independent/create-cluster-kubeadm/)
* [Vagrant Centos kubernetes cluster - https://github.com/clifinger/vagrant-centos-kubernetes](https://github.com/clifinger/vagrant-centos-kubernetes)
* [kubeadm을 이용한 Linux에 Kubernetes 설치하기 - http://xoit.tistory.com/6](http://xoit.tistory.com/6)

