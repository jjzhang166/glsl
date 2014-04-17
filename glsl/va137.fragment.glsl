// ---------------------------------------------- //
// by Stv - Basic sample                          //
// Just added iq's radial blur from Shader Toy.   //
// ---------------------------------------------- //

#ifdef GL_ES
precision highp float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
uniform sampler2D tex0;
uniform sampler2D tex1;

vec3 deform( in vec2 p )
{
    vec2 uv;

    vec2 q = vec2( sin(1.1*time+p.x),sin(1.2*time+p.y) ) + ( gl_FragCoord.xy / resolution.xy );

    float a = atan(q.y,q.x);
    float r = sqrt(dot(q,q));

    uv.x = sin(0.0+1.0*time)+p.x*sqrt(r*r+1.0);
    uv.y = sin(0.6+1.1*time)+p.y*sqrt(r*r+1.0);

    return texture2D(tex0,uv*.5).xyz;
}

void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xy );

	float color = 0.0;
	color += sin( position.x * cos( time / 15.0 ) * 80.0 ) + cos( position.y * cos( time / 15.0 ) * 10.0 );
	color += sin( position.y * sin( time / 10.0 ) * 40.0 ) + cos( position.x * sin( time / 25.0 ) * 40.0 );
	color += sin( position.x * sin( time / 5.0 ) * 10.0 ) + sin( position.y * sin( time / 35.0 ) * 80.0 );
	color *= sin( time / 10.0 ) * 0.5;

	vec2 p = -1.0 + 2.0 * gl_FragCoord.xy / resolution.xy;
	vec2 s = p;

        vec3 total = vec3(0.0);
        vec2 d = (vec2(0.0,0.0)-p)/40.0;
        float w = 1.0;

        for( int i=0; i<40; i++ )
        {
            vec3 res = deform(s);
            res = smoothstep(0.1, 1.0, res*res);
            total += w*res;
            w *= .99;
            s += d;
        }

        total /= 40.0;
        float r = 1.5/(1.0+dot(p,p));

	gl_FragColor = vec4( vec3( color, color * 0.5, sin( color + time / 3.0 ) * 0.75 ) + total, 1.0);

}