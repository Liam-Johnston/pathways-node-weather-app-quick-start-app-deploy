const secrets_manager = require('@aws-sdk/client-secrets-manager')
const { Octokit } = require("@octokit/core")


const __get_client = () => {
  return new secrets_manager.SecretsManagerClient({region: process.env.AWS_DEFAULT_REGION})
}


const get_secret = async (key_id) => {
  let client = __get_client()
  return await client.send(new secrets_manager.GetSecretValueCommand({SecretId: key_id}))
    .then( data => data.SecretString)
}


const main = async () => {
  const access_token = await get_secret("liamjohnston/node-weather-app/github-workflow-access-token")

  const octokit = new Octokit({
    auth: access_token
  })

  await octokit.request("POST /repos/{owner}/{repo}/actions/workflows/{workflow_id}/dispatches", {
    owner: process.env.GITHUB_USERNAME,
    repo: process.env.GITHUB_REPO,
    workflow_id: 'rebuild.yml',
    ref: 'master'
  })
}

main()
