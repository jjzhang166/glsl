#ifdef GL_ES
precision highp float;
#endif
//taken from http://www.iquilezles.org/apps/shadertoy///

const int MAX_ITERATIONS = 256;
uniform vec2 resolution;
uniform float time;
uniform sampler2D tex0;
uniform sampler2D tex1;
vec3 hsv(float h,float s,float v) { return mix(vec3(1.),clamp((abs(fract(h+vec3(3.,2.,1.)/3.)*6.-3.)-1.),0.,1.),s)*v; }
vec3 colorMap(float v) {return hsv(mod(v + time/10.0, 1.0), sin(v + time/3.0)/3. + 0.6, 1.0);}

void main(void)
{
    vec2 p = -1.0 + 2.0 * gl_FragCoord.xy / resolution.xy;
    p.x *= resolution.x/resolution.y;

    float zoo = .800+.38*sin(.1*time);
    float coa = cos( 0.1*(1.0-zoo)*time );
    float sia = sin( 0.1*(1.0-zoo)*time );
    zoo = pow( zoo,8.0);
    vec2 xy = vec2( p.x*coa-p.y*sia, p.x*sia+p.y*coa);
    vec2 cc = vec2(-.74656,.186) + xy*zoo;

    vec2 z  = vec2(0.0);
    vec2 z2 = z*z;
    float m2;
    float co = 0.0;


    for( int i=0; i<MAX_ITERATIONS; i++ )
    {
        if( m2<1024.0 )
        {
            z = cc + vec2( z.x*z.x - z.y*z.y, 2.0*z.x*z.y );
            m2 = dot(z,z);
            co += 1.0;
        }
    }

    if(int(co)<MAX_ITERATIONS-1) gl_FragColor = vec4( colorMap(pow(float(co)/float(MAX_ITERATIONS), 0.8)),1.0 );
}