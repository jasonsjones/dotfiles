module.exports = {
    config: {
        // default font size in pixels for all tabs
        fontSize: 11,

        // font family with optional fallbacks
        fontFamily: '"Fira Code", "Meslo LG S for Powerline", "Lucida Console", monospace',

        // terminal cursor background color and opacity (hex, rgb, hsl, hsv, hwb or cmyk)
        cursorColor: 'rgba(248,28,229,0.75)',

        // `BEAM` for |, `UNDERLINE` for _, `BLOCK` for █
        cursorShape: 'BLOCK',

        // color of the text
        foregroundColor: '#fff',

        // terminal background color
        backgroundColor: '#000',

        // border color (window, tabs)
        borderColor: '#333',

        // custom css to embed in the main window
        css: `
            .line {
                color: #ccc;
            }
            .line .icon g {
                fill: #ccc;
            }
        `,

        // custom css to embed in the terminal window
        termCSS: '',

        // custom padding (css format, i.e.: `top right bottom left`)
        padding: ' 12px 12px 20px 12px',

        // the full list. if you're going to provide the full color palette,
        // including the 6 x 6 color cubes and the grayscale map, just provide
        // an array here instead of a color map object
        colors: {
            black: '#000000',
            red: '#ff0000',
            green: '#33ff00',
            yellow: '#ffff00',
            blue: '#0066ff',
            magenta: '#cc00ff',
            cyan: '#00ffff',
            white: '#d0d0d0',
            lightBlack: '#808080',
            lightRed: '#ff0000',
            lightGreen: '#33ff00',
            lightYellow: '#ffff00',
            lightBlue: '#0066ff',
            lightMagenta: '#cc00ff',
            lightCyan: '#00ffff',
            lightWhite: '#ffffff'
        },

        // the shell to run when spawning a new session (i.e. /usr/local/bin/fish)
        // if left empty, your system's login shell will be used by default
        shell: '',
        activeTab: '🚀',
        webGLRenderer: false,
        // hyperline: {
        //     plugins: ['hostname', 'ip', 'memory']
        // },

        // for advanced config flags please refer to https://hyperterm.org/#cfg
    },

    // a list of plugins to fetch and install from npm
    // format: [@org/]project[#version]
    // examples:
    //   `hyperpower`
    //   `@company/project`
    //   `project#1.0.1`
    /*
        old plugins:
            'hyper-solarized-dark', 'hyper-snazzy', "hyperterm-monokai"
            'hyper-blink',
            'hyper-search',
            'hyperline', // caused much lag in typing in hyper v3.1.x
            'hypercwd',
    */
    plugins: [
        'hyper-font-ligatures',
        'hyper-active-tab',
        'hyper-one-dark'
    ],

    // in development, you can create a directory under
    // `~/.hyperterm_plugins/local/` and include it here
    // to load it and avoid it being `npm install`ed
    localPlugins: []
};
