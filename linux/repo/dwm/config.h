/* See LICENSE file for copyright and license details. */

/* appearance */
static const unsigned int borderpx  = 1;        /* border pixel of windows */
static const unsigned int snap      = 32;       /* snap pixel */
static const int showbar            = 1;        /* 0 means no bar */
static const int topbar             = 1;        /* 0 means bottom bar */
static const char *fonts[]          = { "monospace:size=14" };	/*标题字体*/
static const char dmenufont[]       = "monospace:size=14";	/*dmenu输入框字体*/
static const char col_gray1[]       = "#222222";
static const char col_gray2[]       = "#444444";
static const char col_gray3[]       = "#bbbbbb";
static const char col_gray4[]       = "#eeeeee";
static const char col_cyan[]        = "#005577";
static const char *colors[][3]      = {
	/*               fg         bg         border   */
	[SchemeNorm] = { col_gray3, col_gray1, col_gray2 },
	[SchemeSel]  = { col_gray4, col_cyan,  col_cyan  },
};

/* tagging */
static const char *tags[] = { "write", "video", "game", "4", "5", "6", "7", "8", "9" };

static const Rule rules[] = {
	/* xprop(1):
	 *	WM_CLASS(STRING) = instance, class
	 *	WM_NAME(STRING) = title
	 */
	/* class      instance    title       tags mask     isfloating   monitor */
	{ "Gimp",     NULL,       NULL,       0,            1,           -1 },
	{ "Firefox",  NULL,       NULL,       1 << 8,       0,           -1 },
};

/* layout(s) */
static const float mfact     = 0.55; /* factor of master area size [0.05..0.95] */
static const int nmaster     = 1;    /* number of clients in master area */
static const int resizehints = 1;    /* 1 means respect size hints in tiled resizals */
static const int lockfullscreen = 1; /* 1 will force focus on the fullscreen window */

static const Layout layouts[] = {
	/* symbol     arrange function */
	{ "[]=",      tile },    /* first entry is default */
	{ "><>",      NULL },    /* no layout function means floating behavior */
	{ "[M]",      monocle },
};

/* key definitions */
#define MODKEY Mod1Mask
#define TAGKEYS(KEY,TAG) \
	{ MODKEY,                       KEY,      view,           {.ui = 1 << TAG} }, \
	{ MODKEY|ControlMask,           KEY,      toggleview,     {.ui = 1 << TAG} }, \
	{ MODKEY|ShiftMask,             KEY,      tag,            {.ui = 1 << TAG} }, \
	{ MODKEY|ControlMask|ShiftMask, KEY,      toggletag,      {.ui = 1 << TAG} },

/* helper for spawning shell commands in the pre dwm-5.0 fashion */
#define SHCMD(cmd) { .v = (const char*[]){ "/bin/sh", "-c", cmd, NULL } }

/* commands */
static char dmenumon[2] = "0"; /* component of dmenucmd, manipulated in spawn() */
static const char *dmenucmd[] = { "dmenu_run", "-m", dmenumon, "-fn", dmenufont, "-nb", col_gray1, "-nf", col_gray3, "-sb", col_cyan, "-sf", col_gray4, NULL };
static const char *termcmd[]  = { "st", NULL };
static const char *volup[] = { "amixer", "sset", "Master", "2%+", "umute", NULL};
static const char *voldown[] = { "amixer", "sset", "Master", "2%-", "umute", NULL};
static const char *voltoggle[] = { "amixer", "sset", "Master", "toggle", NULL}; /*定义声音调节和开关功能*/
static const char *lightup[] = { "xbacklight", "-inc", "2", NULL };
static const char *lightdown[] = { "xbacklight", "-dec", "2", NULL }; /*定义捧亩亮度调节功能*/

static const Key keys[] = {
	/* modifier                     key        function        argument */
	{ MODKEY,			XK_F12,     spawn,          {.v = lightup} },
	{ MODKEY,			XK_F11,     spawn,          {.v = lightdown} },
	{ MODKEY,			XK_F3,    spawn,          {.v = volup} }, 	/*调节声音*/
	{ MODKEY,			XK_F2,    spawn,          {.v = voldown} },
	{ MODKEY,			XK_F1,     spawn,          {.v = voltoggle} }, 	/*调节亮度*/
	{ MODKEY,                       XK_p,      spawn,          {.v = dmenucmd } }, 	/*打开dmenu*/
	{ MODKEY|ShiftMask,             XK_Return, spawn,          {.v = termcmd } }, 	/*打开终端*/
	{ MODKEY,                       XK_b,      togglebar,      {0} }, 		/*隐藏状态栏*/
	{ MODKEY,                       XK_j,      focusstack,     {.i = +1 } },
	{ MODKEY,                       XK_k,      focusstack,     {.i = -1 } }, 	/*切换焦点*/
	{ MODKEY,                       XK_i,      incnmaster,     {.i = +1 } },
	{ MODKEY,                       XK_d,      incnmaster,     {.i = -1 } }, 	/*用不明白*/
	{ MODKEY,                       XK_h,      setmfact,       {.f = -0.05} },
	{ MODKEY,                       XK_l,      setmfact,       {.f = +0.05} },	/*主次分区调节*/
	{ MODKEY,                       XK_Return, zoom,           {0} },		/*主次分区切换*/
	{ MODKEY,                       XK_Tab,    view,           {0} },		/*切tag*/
	{ MODKEY|ShiftMask,             XK_c,      killclient,     {0} },		/*关闭当前窗口*/
	{ MODKEY,                       XK_t,      setlayout,      {.v = &layouts[0]} }, /*正常分区模式*/
	{ MODKEY,                       XK_f,      setlayout,      {.v = &layouts[1]} }, /*左上角悬浮，不分区*/
	{ MODKEY,                       XK_m,      setlayout,      {.v = &layouts[2]} }, /*全屏层叠，不分区*/
	{ MODKEY,                       XK_space,  setlayout,      {0} },		/*切换模式*/
	{ MODKEY|ShiftMask,             XK_space,  togglefloating, {0} },		/*不懂*/
	{ MODKEY,                       XK_0,      view,           {.ui = ~0 } },	/**/
	{ MODKEY|ShiftMask,             XK_0,      tag,            {.ui = ~0 } },	/*切换tag*/
	{ MODKEY,                       XK_comma,  focusmon,       {.i = -1 } },
	{ MODKEY,                       XK_period, focusmon,       {.i = +1 } },	/*显示器？*/
	{ MODKEY|ShiftMask,             XK_comma,  tagmon,         {.i = -1 } }, 
	{ MODKEY|ShiftMask,             XK_period, tagmon,         {.i = +1 } },	/*显示器？*/
	TAGKEYS(                        XK_1,                      0)
	TAGKEYS(                        XK_2,                      1)
	TAGKEYS(                        XK_3,                      2)
	TAGKEYS(                        XK_4,                      3)
	TAGKEYS(                        XK_5,                      4)
	TAGKEYS(                        XK_6,                      5)
	TAGKEYS(                        XK_7,                      6)
	TAGKEYS(                        XK_8,                      7)
	TAGKEYS(                        XK_9,                      8)
	{ MODKEY|ShiftMask,             XK_q,      quit,           {0} },
};

/* button definitions */
/* click can be ClkTagBar, ClkLtSymbol, ClkStatusText, ClkWinTitle, ClkClientWin, or ClkRootWin */
static const Button buttons[] = {
	/* click                event mask      button          function        argument */
	{ ClkLtSymbol,          0,              Button1,        setlayout,      {0} },
	{ ClkLtSymbol,          0,              Button3,        setlayout,      {.v = &layouts[2]} },
	{ ClkWinTitle,          0,              Button2,        zoom,           {0} },
	{ ClkStatusText,        0,              Button2,        spawn,          {.v = termcmd } },
	{ ClkClientWin,         MODKEY,         Button1,        movemouse,      {0} },
	{ ClkClientWin,         MODKEY,         Button2,        togglefloating, {0} },
	{ ClkClientWin,         MODKEY,         Button3,        resizemouse,    {0} },
	{ ClkTagBar,            0,              Button1,        view,           {0} },
	{ ClkTagBar,            0,              Button3,        toggleview,     {0} },
	{ ClkTagBar,            MODKEY,         Button1,        tag,            {0} },
	{ ClkTagBar,            MODKEY,         Button3,        toggletag,      {0} },
};

