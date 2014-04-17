#ifdef GL_ES
precision mediump float;
#endif


        uniform sampler2D _MainTex;
        uniform sampler2D _GridTex;
        varying vec2 the_uv;
	varying vec4 color;

        void main()
        {
            if (texture2D(_MainTex, the_uv).a * color.a > texture2D(_GridTex, vec2(gl_FragCoord.x, gl_FragCoord.y)*.25).a) gl_FragColor = color; 
            else gl_FragColor = vec4(0.0, 0.0, 0.0, 0.0);   

        }


