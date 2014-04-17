//IQ Version - http://pouet.net/topic.php?which=7931
// las style mod - might be a good alternative in some situations
// rotwang: @mod+ smooth shape, animation
#ifdef GL_ES
precision highp float;

#endif

uniform vec2 resolution;
uniform float time;

float smoothHexPrism( vec2 p, float h, float smooth )
{
    vec2 q = abs(p) ;
    float d = dot(q, vec2(0.866025, 0.5));
	d += d*sin(time)*0.5;
	
	float shade = max(d, q.y)-h;
	 shade = smoothstep(0.0+smooth, 0.0-smooth, shade);
    return shade;
}

void main(void)
{

    vec2 p = -2.0 + 4.0 * gl_FragCoord.xy / resolution.xy;

    p.x /= resolution.y/resolution.x;

    float shade = smoothHexPrism( p, 1.0, 0.03 );
  shade += 1.0 - length(p);	
 
    vec3 col = vec3(shade*0.2, shade*0.6, shade*1.0);

    gl_FragColor = vec4(col,1.0);
}