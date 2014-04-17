//screwing our lovely mathician's shaders for some fun and no profit :D
#ifdef GL_ES
precision highp float;
#endif

uniform vec2 resolution;
uniform float time;

float HexPrism( vec2 p, float h )
{
    vec2 q = abs(p);
    return max(dot(q, vec2((0.866025 + 0.5*sin(time)) , 0.6 + 0.7*cos(time) )), q.y)-h;
}

float udBox( vec3 p, vec3 b )
{
  return length(max(abs(p)-b,0.0));
}

float sdBox( vec3 p, vec3 b )
{
  vec3  di = abs(p) - b;
  float mc = max(max(di.x, di.y), di.z);
  return min(mc, length(max(di,0.3)));
}

float fbox(vec3 p, vec3 s) {
        vec3 d = abs(p) - s;
        float m = max(d.x,max(d.y, d.z));
        return mix(m, length(max(d, 0.0)),step(0.,m));
}

vec4 distance2Color(float d) {
	vec4 c = mix(vec4(1,1,1,1), vec4(1,1,1,1), d * 0.5 + 0.7);
	c *= abs(d);
	c *= 1. - smoothstep(abs(d), 0.0, 0.15);
	return c;
}	

void main(void)
{
    vec2 p = -1.0 + 2.0 * gl_FragCoord.xy / resolution.xy;
    p.x *= resolution.x / resolution.y;
    p *= 1.5;
	
    float d1 = HexPrism( p, 1.0 );
    float d2 = length(p) - 1.;
    float d3 = udBox(vec3(p, 0.), vec3(1.));
    float d4 = sdBox(vec3(p, 0.), vec3(1.));
    float d5 = fbox(vec3(p, 0.), vec3(1.));
	
	

    gl_FragColor = distance2Color(d1+d2*(d3+0.5*tan(time*3.14))-d4*d5);
}