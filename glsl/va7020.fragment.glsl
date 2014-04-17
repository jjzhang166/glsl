//IQ Version - http://pouet.net/topic.php?which=7931
// las style mod - might be a good alternative in some situations
// rotwang: @mod+ smooth shape, animation
// @mod+ concave, modshape
#ifdef GL_ES
precision highp float;

#endif

uniform vec2 resolution;
uniform float time;

float shape( vec2 p, float h, float smooth )
{
	float m = 0.25;
	p.x = mod(abs(p.x), m) + 0.0/ m;
	float len = length(p)*.5-abs(p.x)*0.5;
	
    vec2 q = abs(p) - len;
    float d = dot(q, vec2(0.866025, 0.5));
	
	
	float shade = max(d, q.y)-h;
	 shade = smoothstep(0.0+smooth, 0.0-smooth, shade);
    return shade;
}




void main(void)
{

    vec2 p = -2.0 + 4.0 * gl_FragCoord.xy / resolution.xy;

    p.x /= resolution.y/resolution.x;

    float shade = shape( p, 0.95, 0.02 );
  shade += 2.0 - length(p);	
 
    vec3 clr = vec3(shade*0.2, shade*0.6, shade);
	clr = mix(clr , clr* max(p.y,0.0),0.5);
	
	
    gl_FragColor = vec4(clr,1.0);
}