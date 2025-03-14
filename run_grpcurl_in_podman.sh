podman container exec repro38916_container \
	grpcurl \
	-plaintext \
	-import-path /work \
	-proto repro_38916.proto \
	-d '{"masterId": "100", "bugs": [ {"bugId": "1", "bugInfo": "hello"}, { "bugId": "2", "bugInfo": "world" } ] }' \
	localhost:50051 \
	repro38916.BugService/SayHelloBug
