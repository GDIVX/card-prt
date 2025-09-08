## Structured description spec for cards and effects
##
## DescriptionSpec lets you build card/effect descriptions from static text
## and dynamic parameters, then render them to a single string given a
## `CardContext`.
##
## Build parts with the static constructors (`text()`, `space()`, `newline()`,
## `param()`), append them via `add()`/`add_all()`/`concat()`, and finally call
## `render(context)` to produce the final text.
##
## Example:
##
## var spec := DescriptionSpec.new()
## spec.add_all([
##     DescriptionSpec.text("Deal"),
##     DescriptionSpec.space(),
##     DescriptionSpec.param("damage", func(ctx: CardContext): return ctx.damage),
##     DescriptionSpec.space(),
##     DescriptionSpec.text("damage."),
## ])
## var result := spec.render(ctx) # e.g. "Deal 5 damage."
class_name DescriptionSpec
extends RefCounted

var parts: Array = []

static func text(t: String) -> Dictionary:
    return {"type": "text", "text": t}

static func space() -> Dictionary:
    return {"type": "text", "text": " "}

static func newline() -> Dictionary:
    return {"type": "text", "text": "\n"}

static func param(name: String, provider: Callable) -> Dictionary:
    # provider: Callable that accepts (context: CardContext) and returns a String/int
    return {"type": "param", "name": name, "provider": provider}

func add(p: Dictionary) -> void:
    parts.append(p)

func add_all(arr: Array) -> void:
    for p in arr:
        parts.append(p)

func concat(other: DescriptionSpec) -> DescriptionSpec:
    if other == null:
        return self
    add_all(other.parts)
    return self

func render(context: CardContext) -> String:
    var out := ""
    for p in parts:
        match p.get("type"):
            "text":
                out += str(p.get("text", ""))
            "param":
                var prov: Callable = p.get("provider")
                if prov and prov.is_valid():
                    var v = prov.call(context)
                    out += str(v)
                else:
                    out += "{" + str(p.get("name", "param")) + "}"
            _:
                out += ""
    return out
