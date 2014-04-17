#ifdef GL_ES
precision mediump float;
#endif
//sexy motion blur :DD
//by MrOMGWTF
// mods by dist
uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
uniform sampler2D bbuff;

float makePoint(vec2 uv, vec2 pos, float rad)
{
	return 1.0 / distance(uv, pos) * rad;	
}

vec2 normalizeduv(vec2 uv) {
	return uv * 2.0 - vec2(1.0, resolution.y/resolution.x);
}

vec2 unnormalizeduv(vec2 uv) {
	return (uv + vec2(1.0, resolution.y/resolution.x))/2.0;
}

void main( void ) {

	vec2 p=(gl_FragCoord.xy/resolution.x)*2.0-vec2(1.0,resolution.y/resolution.x);
	vec2 uv = ( gl_FragCoord.xy / resolution.xy );
	vec3 color;

	for(float i=0.0;i<3.1415*2.0;i+=2.*3.1415/10.) {
		vec2 pointPos = vec2(cos(time*i)*0.5*(i/3.1415), sin(time*i)*0.5*(i/3.1415));
		color += makePoint(p, pointPos, 0.002);
	}
	color = pow(color, vec3(0.9, 1.5, 1.7));
//	color += texture2D(bbuff, vec2(uv) + vec2(0.001, 0.005)).rgb * 0.495*0.95;
//	color += texture2D(bbuff, vec2(uv) - vec2(0.001, 0.005)).rgb * 0.495*0.95;
	color += texture2D(bbuff, uv).rgb*0.9;
	gl_FragColor = vec4( color, 1.0 );

}