#ifdef GL_ES
precision mediump float;
#endif

#define METABALL_NUM 5
#define BALL_DISTANCE 400.0
uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

const float size = 100.0;

struct Obj{
	vec2 pos;
};

void main( void ) {

	Obj m_ball[METABALL_NUM];
	float color;
	for(int i = 0; i < METABALL_NUM - 1; i++)
	{
		m_ball[i].pos.x = resolution.x / 2.0 + BALL_DISTANCE * pow(-1.0 , float(i));
		m_ball[i].pos.y = resolution.y / 2.0 + BALL_DISTANCE * float(i) / 3.0;
	}
	m_ball[4].pos = resolution*mouse;
	
	for(int i = 0; i < METABALL_NUM ; i++)
	{
		float dist = length(gl_FragCoord.xy - m_ball[i].pos);
		if(dist < size)
		{
			color += 1.0;
		}
		
	}
	gl_FragColor = vec4( vec3( color, color * 0.5, sin( color + time / 3.0 ) * 0.75 ), 1.0 );

}