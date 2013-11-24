#-*- tab-width: 4; -*-
# ex:ts=4
# $FreeBSD$

PORTNAME=		ghost
PORTVERSION=	0.3.3
CATEGORIES=		www
MASTER_SITES=	https://ghost.org/archives/

MAINTAINER=		jakob@gillich.me
COMMENT=		Simple blogging platform

LICENSE=		MIT

RUN_DEPENDS=	node:${PORTSDIR}/www/node
BUILD_DEPENDS=	${RUN_DEPENDS} \
				npm:${PORTSDIR}/www/npm

USE_ZIP=		yes
NO_BUILD=		yes

WRKSRC=			${WRKDIR}/${PORTNAME}

OPTIONS_MULTI=	DB
OPTIONS_MULTI_DB=	MYSQL PGSQL SQLITE
OPTIONS_DEFAULT=	SQLITE
MYSQL_USE=		MYSQL=client
PGSQL_USE=		PGSQL=yes
SQLITE_USE=		SQLITE=yes

PLIST=		${WRKDIR}/plist

CPIO?=		/usr/bin/cpio
SORT?=		/usr/bin/sort

do-extract:
	${MKDIR} ${WRKSRC}
	${LOCALBASE}/bin/unzip -d ${WRKSRC} ${DISTDIR}/${DISTFILES}

pre-install:
	cd ${WRKSRC} && npm install --sqlite=${PREFIX}
	${ECHO_CMD} "@mode 755" >> ${PLIST}; ${ECHO_CMD} "@comment files" >> ${PLIST}
	cd ${WRKSRC}; ${FIND} . -type f | cut -c2- \
		| ${SED} 's|^|www/ghost|' \
		| ${SORT} -r >> ${PLIST}
	${ECHO_CMD} "@comment directories" >> ${PLIST}
	cd ${WRKSRC}; ${FIND} . -type d | cut -c2- \
		| ${SED} 's|^|@dirrm www/ghost|' \
		| ${SORT} -r >> ${PLIST}
	${ECHO_CMD} "@mode" >> ${PLIST}

do-install:
	${MKDIR} ${STAGEDIR}${WWWDIR}
	cd ${WRKSRC} && ${COPYTREE_SHARE} . ${STAGEDIR}${WWWDIR}

.include <bsd.port.mk>
