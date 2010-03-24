CREATE TABLE "stat_info" (
		"stat_time" INTEGER PRIMARY KEY
		);

CREATE TABLE "Sensors" ( --网探(即审计节点)
		"id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
		"name" VARCHAR(50) NOT NULL,
		"ip" VARCHAR(16) NOT NULL,
		"model" TEXT,    --型号
		"deleted" BOOLEAN DEFAULT(0)
		);

CREATE TABLE "Roles" (   --角色
		"id" INTEGER PRIMARY KEY AUTOINCREMENT,
		"name" VARCHAR(50) NOT NULL,
		"deleted" BOOLEAN DEFAULT(0)
		);

CREATE TABLE "Users" (   --系统用户
		"id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
		"name" VARCHAR(50) NOT NULL,
		"password" VARCHAR(50) NOT NULL,
		"role_id" INTEGER NOT NULL, --角色
		"restrict_ip" BOOLEAN DEFAULT(0),  --是否限制IP，1: 限制，0-不限制
		"permited_ip" VARCHAR(16), --允许的ip
		"new_password" VARCHAR(50) DEFAULT(''), --新密码
		"active" INTEGER NOT NULL DEFAULT(0),   --1: 允许登录，0-不允许登录
		"deleted" BOOLEAN DEFAULT(0)
		);

CREATE TABLE "OperationLogs" (  --操作日志
		"id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
		"occur_time" INTEGER NOT NULL,  --操作时间
		"user_id" INTEGER NOT NULL, --操作者
		"from_ip" VARCHAR(16) NOT NULL,    --操作者ip
		"operation_id" TEXT NOT NULL,   --操作（外键，operation表）
		"object_id" INTEGER,   --操作对象（外键，据operation_id可确定具体的表）
		"object_name" VARCHAR(50),  --操作对象名称
		"result" TEXT,
		"description" TEXT
		);

CREATE TABLE "Operations" (    --操作(可理解为功能、权限)
		"id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
		"name" TEXT NOT NULL,
		"roles" INTEGER NOT NULL,
		"log" INTEGER NOT NULL,
		"operation" TEXT NOT NULL  --操作(请求URL，如/user/add))
);

CREATE TABLE "AuditSites" (   --审计对象
		"id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
		"name" VARCHAR(50) NOT NULL,
		"sensor_id" INTEGER DEFAULT(0),   --所属审计节点
		"active" BOOLEAN DEFAULT(0),   --是否启用，1-启用，0-禁用
		"deleted" BOOLEAN DEFAULT(0)
		);

CREATE TABLE "AuditServices" (  --被审服务
		"id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
		"audit_site_id" INTEGER NOT NULL, --所属审计对象
		"name" VARCHAR(50) NOT NULL,
		"service_type" INTEGER NOT NULL, --服务类型
		"ip" VARCHAR(16) NOT NULL,
		"port" INTEGER NOT NULL,
		--以下字段只对service_type为3-SERVICE_WEB的服务有意义
		"ip_connect_db" VARCHAR(16),    --双网卡机器连接数据库所用ip
		"login_req" TEXT,   --应用用户登录所发请求
		"user_field" TEXT,  --登录请求中的用户名字段名
		"session_field" TEXT,  --此应用的session字段名
		"deleted" BOOLEAN DEFAULT(0)
		);

CREATE TABLE "IpGroups" (   --ip组
		"id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
		"name" VARCHAR(50) NOT NULL,
		"members" TEXT,  --格式:"192.168.1.10, 192.168.1.50-192.168.1.60, ..."
		"deleted" BOOLEAN DEFAULT(0)
		);

CREATE TABLE "UserGroups" ( --用户组
		"id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
		"name" VARCHAR(50) NOT NULL,
		"members" TEXT,  --格式:"username1,username2,..."
		"deleted" BOOLEAN DEFAULT(0)
		);

CREATE TABLE "RoleOperationss" (    --角色、操作的多对多关系
		"role_id" INTEGER NOT NULL,
		"operation_id" INTEGER NOT NULL
		);

CREATE TABLE "ResponseSnmps" (  --snmp响应
		"id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
		"name" VARCHAR(50) NOT NULL,
		"receiver_ip" VARCHAR(16) NOT NULL, --snmp接受方ip
		"community" TEXT NOT NULL,
		"deleted" BOOLEAN DEFAULT(0)
		);

CREATE TABLE "ResponseEmails" (  --邮件响应
		"id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
		"name" VARCHAR(50) NOT NULL,
		"email" VARCHAR(50) NOT NULL,
		"smtp_ip" VARCHAR(16) NOT NULL DEFAULT('127.0.0.1') ,
		"smtp_user" VARCHAR(50) NOT NULL DEFAULT(''),
		"smtp_password" VARCHAR(20) NOT NULL DEFAULT(''),
		"deleted" BOOLEAN DEFAULT(0)
		);

CREATE TABLE "ResponseSyslogs" (    --syslog响应
		"id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
		"name" VARCHAR(50) NOT NULL,
		"syslogd_ip" VARCHAR(16) NOT NULL,
		"syslogd_port" INTEGER NOT NULL,
		"ident" VARCHAR(20) NOT NULL,
		"facility" VARCHAR(20) NOT NULL,
		"deleted" BOOLEAN DEFAULT(0)
		);

CREATE TABLE "Policies" (   --审计策略
		"id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
		"service_id" INTEGER NOT NULL,
		"priority" INTEGER NOT NULL,
		"name" VARCHAR(50) NOT NULL,
		"response_type" INTEGER NOT NULL, --响应方式：目前只有0-不记录，1-记录
		"criticality" INTEGER NOT NULL,   --危急度, 0-可忽略(不记入事件表), 1-普通, 2-重要, 3-严重
		"time_start" VARCHAR(50) NOT NULL DEFAULT(0),  --格式：HHMMSS
		"time_stop" VARCHAR(50) NOT NULL DEFAULT(235959),    --格式：HHMMSS
		"monday" INTEGER NOT NULL DEFAULT(0),
		"tuesday" INTEGER NOT NULL DEFAULT(0),
		"wednesday" INTEGER NOT NULL DEFAULT(0),
		"thursday" INTEGER NOT NULL DEFAULT(0),
		"friday" INTEGER NOT NULL DEFAULT(0),
		"saturday" INTEGER NOT NULL DEFAULT(0),
		"sunday" INTEGER NOT NULL DEFAULT(0),
		"user_group_id" INTEGER,    --数据库用户名所属组id
		"ip_group_id" INTEGER,  --数据库直接客户端ip所属组id
		"operations" TEXT,  --数据库操作
		"object" TEXT,   --数据库操作对象(表名、视图名、存储过程名等)
		"keyword" TEXT, --请求所含关键字
"keyword_include" BOOLEAN DEFAULT(1),   --1：包含关键字，0：不包含关键字
"deleted" BOOLEAN DEFAULT(0)
);

CREATE TABLE "QueryCriterias" ( --保存的查询条件
		"id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
		"name" VARCHAR(50) NOT NULL,
		"criteria" VARCHAR(400),
		"deleted" BOOLEAN DEFAULT(0)
		);

CREATE TABLE "PolicyApps" ( --策略应用操作条件
		"id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
		"policy_id" INTEGER NOT NULL,  --对应policy记录id
		"service_type" INTEGER, --应用服务类型
		"request" TEXT,    --请求
		"user_group_id" INTEGER,    --应用用户所属组id
		"ip_group_id" INTEGER,  --应用用户ip所属组id
		"keyword" TEXT, --请求所含关键字
		"keyword_include" BOOLEAN DEFAULT(1),   --1：包含关键字，0：不包含关键字
		"deleted" BOOLEAN DEFAULT(0)
		);

CREATE TABLE "PolicyDbs" (  --策略数据库操作条件
		"id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
		"policy_id" INTEGER NOT NULL,  --对应policy记录id
		"user_group_id" INTEGER,    --数据库用户名所属组id
		"ip_group_id" INTEGER,  --数据库直接客户端ip所属组id
		"db_operations" TEXT,  --数据库操作
		"db_object" TEXT,   --数据库操作对象(表名、视图名、存储过程名等)
		"keyword" TEXT, --请求所含关键字
		"keyword_include" BOOLEAN DEFAULT(1),   --1：包含关键字，0：不包含关键字
		"deleted" BOOLEAN DEFAULT(0)
		);

CREATE TABLE "PolicyRespSyslogs" ( --策略syslog响应
		"id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
		"policy_id" INTEGER NOT NULL,  --对应policy记录id
		"resp_id" INTEGER NOT NULL, --对应响应记录id
		"level" TEXT NOT NULL,    --syslog级别
		"deleted" BOOLEAN DEFAULT(0)
		);

CREATE TABLE "PolicyRespEmails" (  --策略邮件响应
		"id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
		"policy_id" INTEGER NOT NULL,  --对应policy记录id
		"resp_id" INTEGER NOT NULL,  --对应response记录id
		"deleted" BOOLEAN DEFAULT(0)
		);

CREATE TABLE "PolicyRespSnmps" (   --策略snmp响应
		"id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
		"policy_id" INTEGER NOT NULL,  --对应policy记录id
		"resp_id" INTEGER NOT NULL,  --对应response记录id
		"deleted" BOOLEAN DEFAULT(0)
		);

--管理员roleid为4
--安全员roleid为2
--审计员roleid为1
--如roleid为6,则表示同时拥有管理员和安全员的权限
INSERT INTO Operations (name,roles,log,operation) VALUES('查询应用',7,0,'/xaudit/webservice/auditsite/fetch');
INSERT INTO Operations (name,roles,log,operation) VALUES('新建应用',4,1,'/xaudit/webservice/auditsite/add');
INSERT INTO Operations (name,roles,log,operation) VALUES('修改应用',4,1,'/xaudit/webservice/auditsite/update');
INSERT INTO Operations (name,roles,log,operation) VALUES('删除应用',4,1,'/xaudit/webservice/auditsite/remove');

INSERT INTO Operations (name,roles,log,operation) VALUES('查询服务',5,0,'/xaudit/webservice/appservice/fetch');
INSERT INTO Operations (name,roles,log,operation) VALUES('新建服务',4,1,'/xaudit/webservice/appservice/add');
INSERT INTO Operations (name,roles,log,operation) VALUES('修改服务',4,1,'/xaudit/webservice/appservice/update');
INSERT INTO Operations (name,roles,log,operation) VALUES('删除服务',4,1,'/xaudit/webservice/appservice/remove');

INSERT INTO Operations (name,roles,log,operation) VALUES('查询服务',5,0,'/xaudit/webservice/dbservice/fetch');
INSERT INTO Operations (name,roles,log,operation) VALUES('新建服务',4,1,'/xaudit/webservice/dbservice/add');
INSERT INTO Operations (name,roles,log,operation) VALUES('修改服务',4,1,'/xaudit/webservice/dbservice/update');
INSERT INTO Operations (name,roles,log,operation) VALUES('删除服务',4,1,'/xaudit/webservice/dbservice/remove');

INSERT INTO Operations (name,roles,log,operation) VALUES('查询IP地址组',5,0,'/xaudit/webservice/ipgroup/fetch');
INSERT INTO Operations (name,roles,log,operation) VALUES('新建IP地址组',4,1,'/xaudit/webservice/ipgroup/add');
INSERT INTO Operations (name,roles,log,operation) VALUES('修改IP地址组',4,1,'/xaudit/webservice/ipgroup/update');
INSERT INTO Operations (name,roles,log,operation) VALUES('删除IP地址组',4,1,'/xaudit/webservice/ipgroup/remove');

INSERT INTO Operations (name,roles,log,operation) VALUES('查询用户组',5,0,'/xaudit/webservice/usergroup/fetch');
INSERT INTO Operations (name,roles,log,operation) VALUES('新建用户组',4,1,'/xaudit/webservice/usergroup/add');
INSERT INTO Operations (name,roles,log,operation) VALUES('修改用户组',4,1,'/xaudit/webservice/usergroup/update');
INSERT INTO Operations (name,roles,log,operation) VALUES('删除用户组',4,1,'/xaudit/webservice/usergroup/remove');

INSERT INTO Operations (name,roles,log,operation) VALUES('查询用户',6,0,'/xaudit/webservice/user/fetch');
INSERT INTO Operations (name,roles,log,operation) VALUES('新建用户',4,1,'/xaudit/webservice/user/add');
INSERT INTO Operations (name,roles,log,operation) VALUES('修改用户密码',4,1,'/xaudit/webservice/user/update');
INSERT INTO Operations (name,roles,log,operation) VALUES('删除用户',4,1,'/xaudit/webservice/user/remove');
INSERT INTO Operations (name,roles,log,operation) VALUES('修改密码',7,1,'/xaudit/webservice/user/changepwd');
INSERT INTO Operations (name,roles,log,operation) VALUES('审核用户',2,1,'/xaudit/webservice/user/review');
INSERT INTO Operations (name,roles,log,operation) VALUES('启用用户',2,1,'/xaudit/webservice/user/enable');
INSERT INTO Operations (name,roles,log,operation) VALUES('禁用用户',2,1,'/xaudit/webservice/user/disable');

INSERT INTO Operations (name,roles,log,operation) VALUES('查询审计策略',7,0,'/xaudit/webservice/policy/fetch');
INSERT INTO Operations (name,roles,log,operation) VALUES('新建审计策略',4,1,'/xaudit/webservice/policy/add');
INSERT INTO Operations (name,roles,log,operation) VALUES('修改审计策略',4,1,'/xaudit/webservice/policy/update');
INSERT INTO Operations (name,roles,log,operation) VALUES('删除审计策略',4,1,'/xaudit/webservice/policy/remove');

INSERT INTO Operations (name,roles,log,operation) VALUES('查询syslog响应',5,0,'/xaudit/webservice/responsesyslog/fetch');
INSERT INTO Operations (name,roles,log,operation) VALUES('新建syslog响应',4,1,'/xaudit/webservice/responsesyslog/add');
INSERT INTO Operations (name,roles,log,operation) VALUES('修改syslog响应',4,1,'/xaudit/webservice/responsesyslog/update');
INSERT INTO Operations (name,roles,log,operation) VALUES('删除syslog响应',4,1,'/xaudit/webservice/responsesyslog/remove');

INSERT INTO Operations (name,roles,log,operation) VALUES('查询email响应',5,0,'/xaudit/webservice/responseemail/fetch');
INSERT INTO Operations (name,roles,log,operation) VALUES('新建email响应',4,1,'/xaudit/webservice/responseemail/add');
INSERT INTO Operations (name,roles,log,operation) VALUES('修改email响应',4,1,'/xaudit/webservice/responseemail/update');
INSERT INTO Operations (name,roles,log,operation) VALUES('删除email响应',4,1,'/xaudit/webservice/responseemail/remove');

INSERT INTO Operations (name,roles,log,operation) VALUES('查询snmp响应',5,0,'/xaudit/webservice/responsesnmp/fetch');
INSERT INTO Operations (name,roles,log,operation) VALUES('新建snmp响应',4,1,'/xaudit/webservice/responsesnmp/add');
INSERT INTO Operations (name,roles,log,operation) VALUES('修改snmp响应',4,1,'/xaudit/webservice/responsesnmp/update');
INSERT INTO Operations (name,roles,log,operation) VALUES('删除snmp响应',4,1,'/xaudit/webservice/responsesnmp/remove');

INSERT INTO Operations (name,roles,log,operation) VALUES('查询系统操作日志',2,0,'/xaudit/webservice/operationlog/fetch');

INSERT INTO Operations (name,roles,log,operation) VALUES('修改审计策略',4,1,'/xaudit/webservice/policydetail/update');

INSERT INTO Operations (name,roles,log,operation) VALUES('查询审计日志',1,0,'/xaudit/webservice/auditevent/fetch');

INSERT INTO Operations (name,roles,log,operation) VALUES('查询会话信息',1,0,'/xaudit/webservice/auditsession/fetch');

INSERT INTO Operations (name,roles,log,operation) VALUES('查询客户端信息',1,0,'/xaudit/webservice/hostinfo/fetch');

INSERT INTO Operations (name,roles,log,operation) VALUES('修改网探IP地址',4,0,'/xaudit/webservice/sysconfig/ipconfig');

INSERT INTO Operations (name,roles,log,operation) VALUES('登录系统',7,1,'/xaudit/webservice/login/index');
INSERT INTO Operations (name,roles,log,operation) VALUES('注销系统',7,1,'/xaudit/webservice/logout/index');

INSERT INTO Users (name,password,role_id,active) VALUES('sysadmin','5baa61e4c9b93f3f0682250b6cf8331b7ee68fd8',4,1);
INSERT INTO Users (name,password,role_id,active) VALUES('sysadmin2','5baa61e4c9b93f3f0682250b6cf8331b7ee68fd8',4,1);
INSERT INTO Users (name,password,role_id,active) VALUES('secadmin','5baa61e4c9b93f3f0682250b6cf8331b7ee68fd8',2,1);
INSERT INTO Users (name,password,role_id,active) VALUES('secadmin2','5baa61e4c9b93f3f0682250b6cf8331b7ee68fd8',2,1);
