#!/bin/bash

entry_point=https://pixe.la/v1
token_header="X-USER-TOKEN:${PIXELA_USER_TOKEN}"

graphs=$(curl -s -X GET ${entry_point}/users/${PIXELA_USER_ID}/graphs -H "$token_header" | jq -r '.graphs[].id')

today=$(date +"%Y%m%d")
tommorow=$(date -v+1d +"%Y%m%d")

output=""
for graph in $graphs;do
	response=$(curl -s -X GET "${entry_point}/users/${PIXELA_USER_ID}/graphs/${graph}/pixels?withBody=true&from=${today}&to=${tommorow}" -H "$token_header")
	total=$(echo $response | jq -r '[.pixels[].quantity] | add // 0')

	output+=$total' '$graph$'\n'
done

echo "$output" | sort -k1n -k2
