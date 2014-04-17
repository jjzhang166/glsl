#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
float segm( float a, float b, float c, float x )
{
    return smoothstep(a-c,a,x) - smoothstep(b,b+c,x);
}
vec3 sun( float x, float y )
{
    float a = atan(x,y);
    float r = sqrt(x*x+y*y);

    float s = 0.5 + 0.5*sin(a*17.0+1.5*time);
    float d = 0.5 + 0.2*pow(s,1.0);
    float h = r/d;
    float f = 1.0-smoothstep(0.92,1.0,h);

    float b = pow(0.5 + 0.5*sin(3.0*time),500.0);
    vec2 e = vec2( abs(x)-0.15,(y-0.1)*(1.0+10.0*b) );
    float g = 1.0 - (segm(0.06,0.09,0.01,length(e)))*step(0.0,e.y);

    float t = 0.5 + 0.5*sin(12.0*time);
    vec2 m = vec2( x, (y+0.15)*(1.0+10.0*t) );
    g *= 1.0 - (segm(0.06,0.09,0.01,length(m)));

    return mix(vec3(1.0),vec3(0.9,0.8,0.0)*g,f);
}
void main( void ) {

    vec2 p = (gl_FragCoord.xy/resolution.xy);

    vec3 col = sun( -1.0+2.0*p.x, -1.0+2.0*p.y );
    gl_FragColor = vec4(col,1.0);
}