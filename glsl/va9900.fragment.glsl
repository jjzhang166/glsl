#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 resolution;
const float PI = 3.1415926;


void main( void )
{
    vec2 pos = -1.0 + 2.0 * gl_FragCoord.xy / resolution.xy;
    float len = length(pos);
    float ang = acos(dot(pos, vec2(0.,-1.))/len);

    vec3 rgb;
    rgb.r = sin(ang*5.);
    rgb.g = cos(ang*20.);
    rgb.b = sin(50.*pos.y * len);
    rgb *= sqrt(len/2.);
	
    float tunnel = abs(sin(pow(len, 0.01)*1000.0 - time*2.0) )/2.0;
    tunnel *= abs(sin(pow(len, 0.1)*200.0 + time*0.1) );
    tunnel *= abs(sin(ang*PI*10.0 - time*0.0))/4.;

    rgb.g += 10.0*len * tunnel;
    rgb.r += 17.0*len*sin(time*1.) * tunnel;

    gl_FragColor = vec4( rgb, 1.0 );
}

                    