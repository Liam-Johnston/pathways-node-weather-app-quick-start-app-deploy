const secretsManager = require('@aws-sdk/client-secrets-manager')
const { Octokit } = require("@octokit/core")


const __get_client = () => {
  return new secretsManager.SecretsManagerClient({region: process.env.AWS_DEFAULT_REGION})
}


const get_secret = async (key_id) => {
  let client = __get_client()
  return await client.send(new secretsManager.GetSecretValueCommand({SecretId: key_id}))
    .then( data => data.SecretString)
}


const main = async (repoName) => {
  const access_token = await get_secret(process.env.GITHUB_TOKEN_SECRET_NAME)

  const octokit = new Octokit({
    auth: access_token
  })

  await octokit.request("POST /repos/{owner}/{repo}/actions/workflows/{workflow_id}/dispatches", {
    owner: process.env.GITHUB_USERNAME,
    repo: repoName,
    workflow_id: 'rebuild.yml',
    ref: 'master'
  })
}

exports.handler = async(event, context) => {
  const SNSMessage = event.Records[0].Sns.Message
  const repoName = snsMessage.split("/").at(-1)

  await main(repoName)
}
