ExUnit.start(capture_log: true)
ExUnit.configure(exclude: [live: true])

fcm_credentials =
  System.fetch_env!("FCM_SERVICE_ACCOUNT_FILE")
  |> File.read!()
  |> Jason.decode!()
  |> Map.fetch!("source_credentials")

workers = [
  {Goth, name: PigeonTest.Goth, source: {:refresh_token, fcm_credentials}},
  PigeonTest.ADM,
  PigeonTest.APNS,
  PigeonTest.APNS.JWT,
  PigeonTest.FCM_V1,
  PigeonTest.FCM,
  PigeonTest.Sandbox
]

Supervisor.start_link(workers, strategy: :one_for_one)
