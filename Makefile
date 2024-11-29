include .env
export

echo:
	@echo AZURE_API_BASE=$(AZURE_API_BASE)
	@echo AZURE_API_KEY=$(AZURE_API_KEY)
	@echo MASTER_KEY=$(MASTER_KEY)

install:
	docker pull ghcr.io/berriai/litellm:main-latest

# RUNNING on http://0.0.0.0:4000
run:
	docker run --rm \
    -v $(PWD)/litellm_config.yaml:/app/config.yaml \
    -e AZURE_API_KEY=$(AZURE_API_KEY) \
    -e AZURE_API_BASE=$(AZURE_API_BASE) \
	-e MASTER_KEY=$(MASTER_KEY) \
    -p 4000:4000 \
    ghcr.io/berriai/litellm:main-latest \
    --config /app/config.yaml --detailed_debug

test_proxy:
	curl -X POST 'http://0.0.0.0:4000/chat/completions' \
		-H 'Content-Type: application/json' \
		-H 'Authorization: Bearer $(MASTER_KEY)' \
		-d '{ \
			"model": "claude35_sonnet", \
			"messages": [ \
				{ \
					"role": "system", \
					"content": "You are a helpful math tutor. Guide the user through the solution step by step." \
				}, \
				{ \
					"role": "user", \
					"content": "how can I solve 8x + 7 = -23" \
				} \
			] \
		}'