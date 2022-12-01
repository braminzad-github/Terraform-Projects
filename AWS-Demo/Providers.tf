provider "aws" {
    region = "ap-southeast-2"
    #profile = "default"
    # assume_role {
    # role_arn = "arn:aws:iam::172264037239:role/DDevOpsCrossAccountAdmin"
    # }
    #user_arn = "arn:aws:iam::946231429173:user/braminzad@deloitte.com.au"
    #role_arn = "arn:aws:iam::141700011076:role/LabRole"

    # Sandpit account
    # access_key = "AKIAZE34QLKIKDO4BA7T"
    # secret_key = "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"

    # NSS Account
    # access_key = "AKIASQG54TN3ZPB76XJD"
    # secret_key = "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"

    profile = "default"
}