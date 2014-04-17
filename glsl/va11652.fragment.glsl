#ifdef GL_ES
precision mediump float;
#endif

#define METABALL_NUM 5
#define BALL_DISTANCE 100.0
uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

const float size = 70.0;
const float range = 10.0;
struct Obj{
	vec2 pos;
};
	
float Blob(vec2 position,vec2 point){
	float temp=pow(position.x-point.x,2.0)+pow(position.y-point.y,2.0);
	float result=0.0;
	if( temp < pow(0.2,2.0)){		
		float distance=sqrt(pow(position.x-point.x,2.0)+pow(position.y-point.y,2.0));		
		result=pow((1.0-pow(distance,2.0)),2.0);		
	}
	return 1.0;
}

void main( void ) {

	Obj m_ball[METABALL_NUM];
	float color;
	for(int i = 0; i < METABALL_NUM - 1; i++)
	{
		m_ball[i].pos.x = resolution.x / 2.0 + BALL_DISTANCE * pow(-1.0 , float(i));
		m_ball[i].pos.y = resolution.y / 2.0 + 2.0*BALL_DISTANCE * float(int((float(i) / 2.0))) - BALL_DISTANCE;
	}
	m_ball[4].pos = resolution*mouse;
	
	for(int i = 0; i < METABALL_NUM ; i++)
	{
		color += Blob(gl_FragCoord.xy/resolution.xy, m_ball[i].pos);	
	}
	gl_FragColor = vec4( vec3( color, color , sin( color + time / 3.0 ) * 0.75 ), 1.0 );

}