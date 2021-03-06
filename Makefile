all: gen-dockerfiles library/caddy

gen-dockerfiles: render-dockerfiles.tmpl Dockerfile.tmpl */*/Dockerfile.base
	@gomplate \
		-t dockerfile=Dockerfile.tmpl \
		-t builder-dockerfile=Dockerfile.builder.tmpl \
		-t windows-dockerfile=Dockerfile.windows.tmpl \
		-c config=./stackbrew-config.yaml \
		-f $<

library/caddy: stackbrew.tmpl stackbrew-config.yaml gen-dockerfiles
	@gomplate \
		--plugin fileCommit=./fileCommit.sh \
		-c config=./stackbrew-config.yaml \
		-f $< \
		-o $@

.PHONY: all gen-dockerfiles
.DELETE_ON_ERROR:
.SECONDARY:
