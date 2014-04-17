// fractal by Dennis Hjorth

#ifdef GL_ES
precision lowp float;
#endif

uniform vec2 resolution;
uniform float time;
uniform sampler2D tex0;
uniform sampler2D tex1;

void main(void)
{
    vec2 v = -1.0 + 2.0 * gl_FragCoord.xy / resolution.xy;
    v.x *= resolution.x/resolution.y;

    v.x += cos(time*0.2);
    v.y += sin(time*0.4);


    float ox = v.x;
    float oy = v.y;
    float ct = cos(time*.2);
    float st = sin(time*.2);
    float px = ox*ct+oy*st;
    float py = oy*ct-ox*st;
    
    vec2 p = vec2(px,py);


    float zoo = 0.48 + 0.22 * cos(0.25 * time);
    float coa = cos( 0.1*(1.0 - zoo) * 0.025*time );
    float sia = sin( 0.1*(1.0 - zoo) * 0.01*time );
    zoo = pow( zoo, 8.0);
    vec2 xy = vec2( p.x*coa-p.y*sia, p.x*sia+p.y*coa);
    vec2 cc = vec2(-.745,.186) + xy*zoo;

    vec2 z  = vec2(0.0);
    vec2 z2 = z*z;
    float m2;
    float co = 0.0;


    for( int i=0; i<256; i++ )
    {
        if( m2<1024.0 )
        {
            z = cc + vec2( z.x*z.x - z.y*z.y, 2.0*z.x*z.y );
            m2 = dot(z,z);
            co += 1.0;
        }
    }

    co = co + 1.0 - log2(.5*log2(m2));

    co = sin(co/4.0);
    float cr = (1.0+sin(time*0.9+time*0.045*6.2831*co/1000.0 - 1.0))*0.4+0.1;
    float cg = (1.0+sin(time*0.7+time*0.05*6.2831*co/1000.0 - 1.0))*0.4+0.1;
    float cb = (1.0+cos(time*0.8+time*0.025*6.2831*co/1000.0 + 2.0))*0.4+0.0;
    gl_FragColor = vec4( cr,cb,cg,
                         1.0 );
}