## ServiceLocator
##
## Global registry for accessing commonly used nodes ("services") by key.
## Register once, then retrieve from anywhere.
##
## Notes:
## - Fails with an error if a key already exists.
## - Keys are strings; use consistent names to avoid collisions.
class_name ServiceLocator
extends Node

## Mapping of service keys to nodes.
var services: Dictionary[String, Node] = {}

## Registers a service under a unique key.
##
## Arguments:
## - [code]key[/code]: Unique identifier for this service.
## - [code]node[/code]: The service instance (any [code]Node[/code]).
func register(key: String, node: Node) -> void:
	assert( not services.has(key) , "Trying to register a service with key " + key + " while already having this key registered")
	services[key] = node

## Returns the service stored at [code]key[/code], or [code]null[/code] if missing.
func get_service(key: String) -> Node:
	assert(services.has(key) , "Key " + key + " was not found")
	return services[key]
