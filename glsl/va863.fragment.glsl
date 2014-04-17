#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	float PI = 3.14159265358979323846264;
                //float r = sqrt(pow(gl_TexCoord[0].x * (t + 1), 2) + pow(gl_TexCoord[0].y * (t + 1), 2));
                float t = time * 10.0;
                float sint = sin(time);
                vec2 op = -1.0 + 2.0 * gl_FragCoord.xy / resolution.xy;
                float x = op.x;
                float y = op.y;
                float d = sqrt((x * x + y * y) / 2.0);
                float x2 = x;
                float y2 = y;
                x = x * d; //atan(x * t + y * t);
                y = y / d;
                x2 = x2 * x2;
                y2 = y2 * y2;
                float r = ((sin(x * (x + y) * 10.0 * PI + t) + 1.0) + (cos(y * 10.0 * PI + t) + 1.0)) / 4.0;
                /*gl_TexCoord[0].y;*/
                float b = ((sin(x2 * (x2 + y2) * 10.0 * PI + t) + 1.0) + (cos(y2 * 10.0 * PI + t) + 1.0)) / 4.0;
                float g = sqrt(r * r + b * b); 

                gl_FragColor = vec4(r, g, b, 0.0);

}