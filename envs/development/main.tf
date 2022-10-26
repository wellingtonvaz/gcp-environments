/**
 * Copyright 2021 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#module "env" {
#  source = "../../modules/env_baseline"
#
#  env                        = "development"
#  environment_code           = "d"
#  monitoring_workspace_users = var.monitoring_workspace_users
#  remote_state_bucket        = var.remote_state_bucket
#}

locals {
  org_id          = data.terraform_remote_state.bootstrap.outputs.common_config.org_id
  parent_folder   = data.terraform_remote_state.bootstrap.outputs.common_config.parent_folder
  parent          = data.terraform_remote_state.bootstrap.outputs.common_config.parent_id

}

data "terraform_remote_state" "bootstrap" {
  backend = "gcs"

  config = {
    bucket = var.remote_state_bucket
    prefix = "terraform/bootstrap/state"
  }
}

data "terraform_remote_state" "org" {
  backend = "gcs"

  config = {
    bucket = var.remote_state_bucket
    prefix = "terraform/org/state"
  }
}
/******************************************
  Development folder
 *****************************************/

resource "google_folder" "env" {
  display_name = "${local.folder_prefix}-${var.env}"
  parent       = local.parent
}

resource "time_sleep" "wait_30_seconds" {
  depends_on = [google_folder.env]

  destroy_duration = "30s"
}