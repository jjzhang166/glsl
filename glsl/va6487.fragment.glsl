#ifdef GL_ES
precision mediump float;
#endif


uniform highp float time;


void main( void )
{
vec2 res = vec2(800.,600.);
vec2 rPos = ( gl_FragCoord.xy/ res.xy );
rPos -= vec2((res.x/res.y)*1.3, (res.y/res.x)/2.);
vec2 uPos;	
uPos.xy=rPos.yx;

float dx =tan( uPos.x*0.9);
float dy =0.6;
vec3 color = vec3(0.0);
float vertColor = 0.0;
const float k = 7.;
for( float i = 1.0; i < k; ++i )
{
    float t = time * cos(0.1*dx) * (1.0);

    uPos.y += tan(2.1*dy) * cos( uPos.x*tan(i) - t) * 0.01;
    float fTemp = abs(1.167/(30.0*k) / uPos.y);
    vertColor += fTemp-t;
    color += vec3( fTemp*(i*0.08) , sin(t/4.)*fTemp*i/k, pow(fTemp,0.93)*1.2*sin(t/6.) );
}

vec4 color_final = vec4(color, 5.0);
gl_FragColor = color_final;
}