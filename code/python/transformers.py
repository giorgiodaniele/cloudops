import re
import pulumi

TAGS = [
    "application",
    "environment",
    "business_unit",
    "owner",
]

def tag_transformer(args: pulumi.ResourceTransformArgs):
    props = args.props
    opts  = args.opts

    if "tags" in props:
        tags = props.get("tags", {})
        for tag in TAGS:
            if tag not in tags:
                tags[tag] = tag
            else:
                tags.pop(tag)

    return pulumi.ResourceTransformResult(props=props, opts=opts)


def register_all():
    pulumi.runtime.register_resource_transform(tag_transformer)