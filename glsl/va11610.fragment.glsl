#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

        const float fog_density = 0.05;

        void main( void ) {

                // Fog
                const float LOG2 = 20.442695;
                // Is the W coord related to the transform part?
                float z = gl_FragCoord.z / gl_FragCoord.w;

                // -fogdensity^2 * z^2 * log(2) => why?
                float fogFactor = exp2( -fog_density * 
                                                   fog_density * 
                                                   z * 
                                                   z * 
                                                   LOG2 );
                fogFactor = clamp(fogFactor, 0.0, 1.0);

                vec4 fog_color = vec4(1,1,1,1.0);

                // gl_FragColor = mix(gl_Fog.color, finalColor, fogFactor );

                vec2 position = -1.0 + gl_FragCoord.xy / resolution.xy;
                float red = abs( sin( position.y * position.y + time / 5.0 ) );
                float green = abs( sin( position.y * position.y + time / 4.0 ) );
                float blue = abs( sin( position.y * position.y + time / 3.0 ) );

                vec4 final_color;
                // final_color.rgba = vec4(red, gree, blue, 1.0);
                final_color.rgba = vec4(0.0, 0.3, 1.0, 1.0);
                final_color.rgba = vec4(1.0, 0.3, 1.0, 1.0);

                gl_FragColor = mix(fog_color, final_color, fogFactor );

                
        }
