FROM centos:5.11

# using epel
#RUN rpm -Uvh http://dl.fedoraproject.org/pub/epel/5/x86_64/epel-release-5-4.noarch.rpm
RUN rpm -Uvh http://dl.fedoraproject.org/pub/epel/5Server/x86_64/epel-release-5-4.noarch.rpm

# update / install
RUN yum -y update
RUN yum -y install mysql mysql-devel mysqlclient mysqlreport perl-DBD-MySQL

RUN rpm -Uvh http://sphinxsearch.com/files/sphinx-2.0.4-1.rhel5.x86_64.rpm
RUN yum -y install sphinx

RUN mkdir /var/lib/sphinx/data
RUN chown -R sphinx:sphinx /var/lib/sphinx

ADD run.sh /
RUN chmod 755 /run.sh

CMD /run.sh
