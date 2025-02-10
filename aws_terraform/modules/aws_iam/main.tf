# Creates a dynamic amount of IAM roles for whatever is defined by the variable iam_roles
resource "aws_iam_role" "iam_roles" {
  for_each = { for role in var.iam_roles : role.name => role }

  name               = each.value.name
  assume_role_policy = each.value.assume_role_policy
  
  tags = merge(
    var.tags,
    {
        Name   = each.value.name
        Module = "aws_iam"
    }
  )
}

# Uses the policies in iam_roles to create policies that will be attached to the role created above
resource "aws_iam_policy" "iam_policies" {
  for_each    = { for policy in flatten([for role in var.iam_roles : role.policies]) : policy.policy_name => policy }
  name        = each.value.policy_name
  description = each.value.description
  policy      = each.value.policy
  
  tags = merge(
    var.tags,
    {
        Name   = each.value.policy_name
        Module = "aws_iam"
    }
  )
}

resource "aws_iam_role_policy_attachment" "iam_role_policies" {
  for_each = { for policy in flatten([for role in var.iam_roles : [
    for policy in role.policies : {
      role_name    = role.name
      policy_name  = policy.policy_name
    }
  ]]) : "${policy.role_name}-${policy.policy_name}" => policy }

  role       = aws_iam_role.iam_roles[each.value.role_name].name
  policy_arn = aws_iam_policy.iam_policies[each.value.policy_name].arn
}
