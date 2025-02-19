.PHONY: assets_gen

assets_gen:
	cd packages/resources && flutter gen-l10n
