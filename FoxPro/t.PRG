CLEAR
DO wwhttp

TEXT TO LCPOST NOSHOW
{ 
	"company" : "CompanyName",
	"firstName" : "Bill", 
	"lastName" : "Bobson", 
	"title" : "TitlePosition", 
	"emails" : ["email1@aol.com"],
	"phones" : ["727-123-1234"]
}
ENDTEXT

oHTTP=CREATEOBJECT("wwHttp")
oHttp.cContentType = "application/json"
oHTTP.AddHeader("Authorization","Bearer gc_notrealsecretcode1234")
oHTTP.AddHeader("accept","application/json")
oHTTP.AddHeader("X-CSRF-TOKEN","")
lcHTML = oHTTP.Post("https://api.grandcentr.al/v1/contact/create", lcPost) 
? lcHtml