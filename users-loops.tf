provider "aws" {
	region = "ap-south-1"
}

resource "aws_iam_user" "example" {
	name = "deng.${count.index}"
	count = 3
}

# now multiple user using list

variable "user_names" {
	description = "create iam users"
	type = "list"
	default = ["kapil", "deng", "yuva"]
}

resource "aws_iam_user" "testing" {
	count = "${length(var.user_names)}"
	name = "${element(var.user_names, count.index)}"
	
}

output "all_arn" {
	value = ["${aws_iam_user.testing.*.arn}"]
}

data "aws_iam_policy_document" "ec2_read_only" {
	statement {
		effect = "Allow"
		actions = ["ec2:Describe*"]
		resources = ["*"]
	}
}

#now create the policy from that document

resource "aws_iam_policy" "ec2_read_only" {
	name = "ec2-read-only"
	policy = "${data.aws_iam_policy_document.ec2_read_only.json}"
}

#now attach iam policy to users

resource "aws_iam_user_policy_attachment" "ec2_access" {
	count = "${length(var.user_names)}"
	user = "${element(aws_iam_user.testing.*.name, count.index)}"
	policy_arn = "${aws_iam_policy.ec2_read_only.arn}"
}
