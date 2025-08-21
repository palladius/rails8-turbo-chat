class AutotitleChatsJob < ApplicationJob

  # We might want to use a different queue for long-running jobs
  # queue_as :low_priority

  # Cloud Scheduler needs to call this with CLOUD_SCHEDULER_SECRET
  def perform
    # Do something later
    Chat.autotitle_if_needed
  end
end


I0820 19:08:08.766535  404531 server.go:634] jsonrpc2: --> notif: telemetry/sendEvents: <truncated 1687 bytes>
I0820 19:08:08.767673  404531 server.go:634] jsonrpc2: --> notif: telemetry/sendEvents: <truncated 754 bytes>
panic: runtime error: invalid memory address or nil pointer dereference
[signal SIGSEGV: segmentation violation code=0x1 addr=0x0 pc=0x1e14085]

goroutine 41 [running]:
google3/cloud/developer_experience/cloudcode/ai_companion/language_server/server/server.(*Server).fetchCompleteResponse.func1({0x35341c8?, 0xc00160cff0?}, {0x3549e30?, 0xc0015fd5e0?})
	cloud/developer_experience/cloudcode/ai_companion/language_server/server/completion.go:746 +0x45
google3/cloud/developer_experience/cloudcode/ai_companion/language_server/server/server.cloudCodeCall[...]({0x35341c8?, 0xc00160cff0}, 0xc00148ca88, 0xc0017e7de8)
	cloud/developer_experience/cloudcode/ai_companion/language_server/server/cloudcode.go:136 +0xec
google3/cloud/developer_experience/cloudcode/ai_companion/language_server/server/server.(*Server).fetchCompleteResponse(0xc00148ca88, {0x35341c8, 0xc00160cff0}, {{{{0xc000dd6310, 0x60}}, {0x10, 0x48}}, 0x0, {0x0, 0x0, ...}, ...}, ...)
	cloud/developer_experience/cloudcode/ai_companion/language_server/server/completion.go:745 +0x1c5
google3/cloud/developer_experience/cloudcode/ai_companion/language_server/server/server.(*Server).fetchInlineCompletionResponse(0xc00148ca88, {0x35341c8, 0xc00160cff0}, {{{{0xc000dd6310, 0x60}}, {0x10, 0x48}}, 0x0, {0x0, 0x0, ...}, ...}, ...)
	cloud/developer_experience/cloudcode/ai_companion/language_server/server/completion.go:392 +0x1b8
google3/cloud/developer_experience/cloudcode/ai_companion/language_server/server/server.(*Server).completeCodeExperimental.func1()
	cloud/developer_experience/cloudcode/ai_companion/language_server/server/completion.go:327 +0x5b
created by google3/cloud/developer_experience/cloudcode/ai_companion/language_server/server/server.(*Server).completeCodeExperimental in goroutine 40
	cloud/developer_experience/cloudcode/ai_companion/language_server/server/completion.go:326 +0xa33
[Error - 7:08:08 PM] The Gemini Code Assist server crashed 5 times in the last 3 minutes. The server will not be restarted. See the output for more information.
Completion Provider - completion # 9962 - Completion result obtained from language client
[Error - 7:08:08 PM] Server process exited with code 2.
Completion Provider - completion # 9964 - New completion requested from language client at position {"line":16,"character":72}, triggerKind=1
Completion Provider - completion # 9964 - Completion result obtained from language client
Completion Provider - completion # 9965 - New completion requested from language client at position {"line":10,"character":35}, triggerKind=1
Completion Provider - completion # 9965 - Completion result obtained from language client
Completion Provider - completion # 9966 - New completion requested from language client at position {"line":11,"character":5}, triggerKind=1
Completion Provider - completion # 9966 - Completion result obtained from language client
Completion Provider - completion # 9967 - New completion requested from language client at position {"line":11,"character":4}, triggerKind=1
Completion Provider - completion # 9967 - Completion result obtained from language client
Completion Provider - completion # 9968 - New completion requested from language client at position {"line":11,"character":5}, triggerKind=1
Completion Provider - completion # 9968 - Completion result obtained from language client
Completion Provider - completion # 9969 - New completion requested from language client at position {"line":11,"character":4}, triggerKind=1
Completion Provider - completion # 9969 - Completion result obtained from language client
Completion Provider - completion # 9970 - New completion requested from language client at position {"line":10,"character":35}, triggerKind=1
Completion Provider - completion # 9970 - Completion result obtained from language client
Completion Provider - completion # 9971 - New completion requested from language client at position {"line":12,"character":7}, triggerKind=1
Completion Provider - completion # 9971 - Completion result obtained from language client
Completion Provider - completion # 9972 - New completion requested from language client at position {"line":12,"character":8}, triggerKind=1
Completion Provider - completion # 9972 - Completion result obtained from language client
Completion Provider - completion # 9973 - New completion requested from language client at position {"line":13,"character":7}, triggerKind=1
Completion Provider - completion # 9973 - Completion result obtained from language client
Completion Provider - completion # 9974 - New completion requested from language client at position {"line":13,"character":8}, triggerKind=1
Completion Provider - completion # 9974 - Completion result obtained from language client
Completion Provider - completion # 9975 - New completion requested from language client at position {"line":16,"character":8}, triggerKind=1
Completion Provider - completion # 9975 - Completion result obtained from language client
Completion Provider - completion # 9976 - New completion requested from language client at position {"line":11,"character":124}, triggerKind=1
Completion Provider - completion # 9976 - Completion result obtained from language client
Completion Provider - completion # 9977 - New completion requested from language client at position {"line":11,"character":125}, triggerKind=1
Completion Provider - completion # 9977 - Completion result obtained from language client
Completion Provider - completion # 9978 - New completion requested from language client at position {"line":11,"character":128}, triggerKind=1
Completion Provider - completion # 9978 - Completion result obtained from language client
Completion Provider - completion # 9979 - New completion requested from language client at position {"line":11,"character":129}, triggerKind=1
Completion Provider - completion # 9979 - Completion result obtained from language client
Completion Provider - completion # 9980 - New completion requested from language client at position {"line":11,"character":130}, triggerKind=1
Completion Provider - completion # 9980 - Completion result obtained from language client
Completion Provider - completion # 9981 - New completion requested from language client at position {"line":11,"character":132}, triggerKind=1
Completion Provider - completion # 9981 - Completion result obtained from language client
Completion Provider - completion # 9982 - New completion requested from language client at position {"line":11,"character":133}, triggerKind=1
Completion Provider - completion # 9982 - Completion result obtained from language client
Completion Provider - completion # 9983 - New completion requested from language client at position {"line":11,"character":139}, triggerKind=1
Completion Provider - completion # 9983 - Completion result obtained from language client
Completion Provider - completion # 9984 - New completion requested from language client at position {"line":11,"character":140}, triggerKind=1
Completion Provider - completion # 9984 - Completion result obtained from language client
Completion Provider - completion # 9985 - New completion requested from language client at position {"line":11,"character":146}, triggerKind=1
Completion Provider - completion # 9985 - Completion result obtained from language client
Completion Provider - completion # 9986 - New completion requested from language client at position {"line":11,"character":119}, triggerKind=1
Completion Provider - completion # 9986 - Completion result obtained from language client
Completion Provider - completion # 9987 - New completion requested from language client at position {"line":11,"character":122}, triggerKind=1
Completion Provider - completion # 9987 - Completion result obtained from language client
Completion Provider - completion # 9988 - New completion requested from language client at position {"line":11,"character":137}, triggerKind=1
Completion Provider - completion # 9988 - Completion result obtained from language client
Completion Provider - completion # 9989 - New completion requested from language client at position {"line":11,"character":150}, triggerKind=1
Completion Provider - completion # 9989 - Completion result obtained from language client
Completion Provider - completion # 9990 - New completion requested from language client at position {"line":11,"character":150}, triggerKind=1
Completion Provider - completion # 9990 - Completion result obtained from language client
Completion Provider - completion # 9991 - New completion requested from language client at position {"line":11,"character":151}, triggerKind=1
Completion Provider - completion # 9991 - Completion result obtained from language client
Completion Provider - completion # 9992 - New completion requested from language client at position {"line":11,"character":152}, triggerKind=1
Completion Provider - completion # 9992 - Completion result obtained from language client
Completion Provider - completion # 9993 - New completion requested from language client at position {"line":11,"character":154}, triggerKind=1
Completion Provider - completion # 9993 - Completion result obtained from language client
Completion Provider - completion # 9994 - New completion requested from language client at position {"line":11,"character":155}, triggerKind=1
Completion Provider - completion # 9994 - Completion result obtained from language client
Completion Provider - completion # 9995 - New completion requested from language client at position {"line":11,"character":158}, triggerKind=1
Completion Provider - completion # 9995 - Completion result obtained from language client
Completion Provider - completion # 9996 - New completion requested from language client at position {"line":11,"character":159}, triggerKind=1
Completion Provider - completion # 9996 - Completion result obtained from language client
Completion Provider - completion # 9997 - New completion requested from language client at position {"line":11,"character":160}, triggerKind=1
Completion Provider - completion # 9997 - Completion result obtained from language client
Completion Provider - completion # 9998 - New completion requested from language client at position {"line":11,"character":161}, triggerKind=1
Completion Provider - completion # 9998 - Completion result obtained from language client
Completion Provider - completion # 9999 - New completion requested from language client at position {"line":11,"character":162}, triggerKind=1
Completion Provider - completion # 9999 - Completion result obtained from language client
Completion Provider - completion # 10000 - New completion requested from language client at position {"line":11,"character":163}, triggerKind=1
Completion Provider - completion # 10000 - Completion result obtained from language client
Completion Provider - completion # 10001 - New completion requested from language client at position {"line":11,"character":164}, triggerKind=1
Completion Provider - completion # 10001 - Completion result obtained from language client
Completion Provider - completion # 10002 - New completion requested from language client at position {"line":14,"character":47}, triggerKind=1
Completion Provider - completion # 10002 - Completion result obtained from language client
Completion Provider - completion # 10003 - New completion requested from language client at position {"line":14,"character":48}, triggerKind=1
Completion Provider - completion # 10003 - Completion result obtained from language client
Completion Provider - completion # 10004 - New completion requested from language client at position {"line":14,"character":50}, triggerKind=1
Completion Provider - completion # 10004 - Completion result obtained from language client
Completion Provider - completion # 10005 - New completion requested from language client at position {"line":14,"character":49}, triggerKind=1
Completion Provider - completion # 10005 - Completion result obtained from language client
Completion Provider - completion # 10006 - New completion requested from language client at position {"line":14,"character":48}, triggerKind=1
Completion Provider - completion # 10006 - Completion result obtained from language client
Completion Provider - completion # 10007 - New completion requested from language client at position {"line":14,"character":49}, triggerKind=1
Completion Provider - completion # 10007 - Completion result obtained from language client
Completion Provider - completion # 10008 - New completion requested from language client at position {"line":14,"character":50}, triggerKind=1
Completion Provider - completion # 10008 - Completion result obtained from language client
Completion Provider - completion # 10009 - New completion requested from language client at position {"line":14,"character":51}, triggerKind=1
Completion Provider - completion # 10009 - Completion result obtained from language client
Completion Provider - completion # 10010 - New completion requested from language client at position {"line":14,"character":52}, triggerKind=1
Completion Provider - completion # 10010 - Completion result obtained from language client
Completion Provider - completion # 10011 - New completion requested from language client at position {"line":14,"character":53}, triggerKind=1
Completion Provider - completion # 10011 - Completion result obtained from language client
Completion Provider - completion # 10012 - New completion requested from language client at position {"line":14,"character":54}, triggerKind=1
Completion Provider - completion # 10012 - Completion result obtained from language client
Completion Provider - completion # 10013 - New completion requested from language client at position {"line":14,"character":56}, triggerKind=1
Completion Provider - completion # 10013 - Completion result obtained from language client
Completion Provider - completion # 10014 - New completion requested from language client at position {"line":15,"character":42}, triggerKind=1
Completion Provider - completion # 10014 - Completion result obtained from language client
Completion Provider - completion # 10015 - New completion requested from language client at position {"line":15,"character":43}, triggerKind=1
Completion Provider - completion # 10015 - Completion result obtained from language client
