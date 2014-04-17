#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
uniform sampler2D backbuffer;
vec2 rand1(vec2 pos)
{
	return fract( pow(pos+2.0+fract(time), pos.yx+2.0 )*22222.0 );
}

vec2 rand0(vec2 pos)//fixd yo
{
	return rand1( rand1 (rand1(pos)));
}

void main( void )
{
	const int U_COLOR = 1;
	const int V_COLOR = 2;
	const float Dt = 1.0;
	const float F = 0.012;
	const float k = 0.05;
	const float ru = 0.01;
	const float rv =  0.005;
	vec2 position = gl_FragCoord.xy / resolution.xy;
	float u,v;
	float u_n[4];
	float v_n[4];
		
	if( mouse.x == 0.0 || time < 1.) {
		vec4 color = vec4(0.0,0.0,0.0,1.0);
		vec2 rand = rand0(position);
		color[U_COLOR] = rand[0];
		color[V_COLOR] = rand[1];

		gl_FragColor = color;

	}else{
		float u = texture2D(backbuffer, gl_FragCoord.xy / resolution.xy )[U_COLOR];
		float v = texture2D(backbuffer, gl_FragCoord.xy / resolution.xy )[V_COLOR];
		u_n[0] = texture2D(backbuffer, (gl_FragCoord.xy+vec2( 0.0,-1.0)) / resolution.xy)[U_COLOR];
		u_n[1] = texture2D(backbuffer, (gl_FragCoord.xy+vec2(-1.0, 0.0)) / resolution.xy)[U_COLOR];
		u_n[2] = texture2D(backbuffer, (gl_FragCoord.xy+vec2( 1.0, 0.0)) / resolution.xy)[U_COLOR];
		u_n[3] = texture2D(backbuffer, (gl_FragCoord.xy+vec2( 0.0, 1.0)) / resolution.xy)[U_COLOR];
		v_n[0] = texture2D(backbuffer, (gl_FragCoord.xy+vec2( 0.0,-1.0)) / resolution.xy)[V_COLOR];
		v_n[1] = texture2D(backbuffer, (gl_FragCoord.xy+vec2(-1.0, 0.0)) / resolution.xy)[V_COLOR];
		v_n[2] = texture2D(backbuffer, (gl_FragCoord.xy+vec2( 1.0, 0.0)) / resolution.xy)[V_COLOR];
		v_n[3] = texture2D(backbuffer, (gl_FragCoord.xy+vec2( 0.0, 1.0)) / resolution.xy)[V_COLOR];
		float du = 0.0;
		float dv = 0.0;
		for(int i=0; i<4; i++) {
			du += u_n[i];
			dv += v_n[i];
		}
		du /= 4.0;
		dv /= 4.0;
		vec4 color = vec4(0.0,0.0,0.0,1.0);
		float uvv = u*v*v;
		color[U_COLOR] = u + Dt * ( -uvv + F * (1.0 - u ) + ru*du);
		color[V_COLOR] = v + Dt * (  uvv - (F + k)*v + rv*dv );
		gl_FragColor = color;
	}
}