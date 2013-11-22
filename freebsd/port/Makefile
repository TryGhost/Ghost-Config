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

do-extract:
	@${MKDIR} ${WRKSRC}
	@${LOCALBASE}/bin/unzip -d ${WRKSRC} ${DISTDIR}/${DISTFILES}

do-install:
	@${MKDIR} ${STAGEDIR}${WWWDIR}
	@cd ${WRKSRC} && \
	npm install --sqlite=${PREFIX} && \
	${COPYTREE_SHARE} . ${STAGEDIR}${WWWDIR}

.include <bsd.port.mk>
