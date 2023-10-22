#pragma once

#ifdef WEBCORE_EXPORT
#	define WEBCORE_API	__declspec(dllexport)
#else
#	define WEBCORE_API	__declspec(dllimport)
#endif

struct IDirect3DTexture9;

enum cef_var_type_t
{
	var_null	= 0,
	var_bool	= 1,
	var_number	= 2,
	var_string	= 3,
};

struct cef_var_t
{
	cef_var_type_t	type;
	union
	{
		const void*	data;
		int			as_bool;
		double*		as_number;
		const char* as_string;
	};
};

typedef void* WebFrame;

typedef void(__stdcall* frame_callback_t)(WebFrame frame); // create, destroy, etc.
typedef void(__stdcall* loading_callback_t)(WebFrame frame, int httpStatusCode);
typedef void(__stdcall* js_callback_t)(WebFrame frame, const char* name, cef_var_t* argv, int argc);

extern "C"
{
	WEBCORE_API const char*			__stdcall CEF_GetVersion();
	WEBCORE_API bool				__stdcall CEF_IsInitialized();
	WEBCORE_API bool				__stdcall CEF_IsAnyInputActive();

	WEBCORE_API WebFrame			__stdcall CEF_Create(const char* url, int x, int y, int w, int h, frame_callback_t callback);
	WEBCORE_API WebFrame			__stdcall CEF_CreateFullscreen(const char* url, frame_callback_t callback);
	WEBCORE_API void				__stdcall CEF_Close(WebFrame frame);

	WEBCORE_API IDirect3DTexture9*	__stdcall CEF_GetTexture(WebFrame frame);

	WEBCORE_API bool				__stdcall CEF_IsInputActive(WebFrame frame);
	WEBCORE_API void				__stdcall CEF_SetInput(WebFrame frame, bool enable);

	WEBCORE_API const char*			__stdcall CEF_GetURL(WebFrame frame);
	WEBCORE_API void				__stdcall CEF_LoadURL(WebFrame frame, const char* url);

	WEBCORE_API bool				__stdcall CEF_CanGoBack(WebFrame frame);
	WEBCORE_API void				__stdcall CEF_GoBack(WebFrame frame);

	WEBCORE_API bool				__stdcall CEF_CanGoForward(WebFrame frame);
	WEBCORE_API void				__stdcall CEF_GoForward(WebFrame frame);

	WEBCORE_API void				__stdcall CEF_SetActive(WebFrame frame, bool enable);
	WEBCORE_API void				__stdcall CEF_SetOffScreen(WebFrame frame, bool enable);
	WEBCORE_API void				__stdcall CEF_SetRect(WebFrame frame, int x, int y, int w, int h);

	WEBCORE_API void				__stdcall CEF_ExecuteJS(WebFrame frame, const char* code);
	WEBCORE_API void				__stdcall CEF_ReloadPage(WebFrame frame, bool ignore_cache);
	WEBCORE_API const char*			__stdcall CEF_GetTitle(WebFrame frame);
	WEBCORE_API bool				__stdcall CEF_IsLoading(WebFrame frame);

	// callbacks
	WEBCORE_API void				__stdcall CEF_SetCreateCallback(WebFrame frame, frame_callback_t callback);
	WEBCORE_API void				__stdcall CEF_SetCloseCallback(WebFrame frame, frame_callback_t callback);
	WEBCORE_API void				__stdcall CEF_SetLoadingCallback(WebFrame frame, loading_callback_t callback);
	WEBCORE_API void				__stdcall CEF_SetJSFunction(WebFrame frame, const char* name, js_callback_t callback);
}
