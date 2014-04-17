#ifdef GL_ES
precision mediump float;
#endif

#define METABALL_NUM 5
#define BALL_DISTANCE 100.0
uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

const float size = 30.0;
const float a_size = 50.0;
struct Obj{
	vec2 pos;
};

void main( void ) {

	Obj m_ball[METABALL_NUM];
	float density = 0.0;
	vec3 color = vec3(0.0);
	for(int i = 0; i < METABALL_NUM - 1; i++)
	{
		m_ball[i].pos.x = resolution.x / 2.0 + BALL_DISTANCE * pow(-1.0 , float(i));
		m_ball[i].pos.y = resolution.y / 2.0 + 2.0*BALL_DISTANCE * float(int((float(i) / 2.0))) - BALL_DISTANCE;
	}
	m_ball[4].pos = resolution*mouse;
	
	for(int i = 0; i < METABALL_NUM ; i++)
	{
		float dist = length(gl_FragCoord.xy - m_ball[i].pos);
		
		density += pow(size/dist,2.0);
		
	}
	
	
	
	if(density > 4.0) {
		color += 1.0;	
	}
	
	else if(density < 3.0,density > 2.0) {
		color = vec3( 0.0 ,1.0,1.0);	
	}
	gl_FragColor = vec4( color, 1.0 );
}