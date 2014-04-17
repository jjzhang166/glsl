#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
uniform sampler2D backbuffer;
vec2 uv;
vec2 mouseUV;
vec4 last;

const vec3 playerColor = vec3(.1, .1, .1);
const vec3 pathColor = vec3(.0, .5, 1.);

int stage = 0;
float xPos;
float stageTime;
	
float rand(vec2 co){
    return fract(sin(dot(co.xy ,vec2(12.9898,78.233))) * 43758.5453);
}


float circle(vec2 center, float radius, vec2 point)
{
	if (length(center - point) <= radius) return 1.0;
	else return 0.0;
}

float rect(vec2 pos, vec2 size, vec2 point)
{
	if (point.x < pos.x) return 0.;
	if (point.y < pos.y) return 0.;
	if (point.x > pos.x + size.x) return 0.;
	if (point.y > pos.y + size.y) return 0.;
	return 1.;
}

float dig1(vec2 pos, float size,  vec2 point)
{
	return rect(vec2(pos.x + .5*size, pos.y), vec2(.1*size,size), point);
}

float dig2(vec2 pos, float size, vec2 point)
{
	float res = 0.;
	
	res += rect(vec2(pos.x, pos.y+.9*size), vec2(size, .1*size), point);
	res += rect(vec2(pos.x+.9*size, pos.y+.45*size), vec2(.1*size, .5*size), point);
	res += rect(vec2(pos.x, pos.y+.45*size), vec2(size, .1*size), point);
	res += rect(pos, vec2(size, .1*size), point);
	res += rect(pos, vec2(.1*size, .5*size), point);
	
	return max(.0,res);
}

float dig3(vec2 pos, float size, vec2 point)
{
	float res = 0.;
	
	res += rect(vec2(pos.x, pos.y+.9*size), vec2(size, .1*size), point);
	res += rect(vec2(pos.x, pos.y+.45*size), vec2(size, .1*size), point);
	res += rect(pos, vec2(size, .1*size), point);
	res += rect(vec2(pos.x+.9*size, pos.y), vec2(.1*size, size), point);
	
	return max(.0,res);	
}

float dig4(vec2 pos, float size, vec2 point)
{
	float res = 0.;
	
	res += rect(vec2(pos.x, pos.y+.45*size), vec2(size, .1*size), point);
	res += rect(vec2(pos.x+.9*size, pos.y), vec2(.1*size, size), point);
	res += rect(vec2(pos.x, pos.y+.45*size), vec2(.1*size, .5*size), point);
	
	return max(.0,res);	
}

float dig5(vec2 pos, float size, vec2 point)
{
	float res = 0.;
	
	res += rect(vec2(pos.x, pos.y+.9*size), vec2(size, .1*size), point);
	res += rect(vec2(pos.x, pos.y+.45*size), vec2(.1*size, .5*size), point);
	res += rect(vec2(pos.x, pos.y+.45*size), vec2(size, .1*size), point);
	res += rect(pos, vec2(size, .1*size), point);
	res += rect(vec2(pos.x+.9*size, pos.y), vec2(.1*size, .5*size), point);
	
	return max(.0,res);	
}

float dig6(vec2 pos, float size, vec2 point)
{
	float res = 0.;
	
	res += rect(vec2(pos.x, pos.y+.9*size), vec2(size, .1*size), point);
	res += rect(vec2(pos.x, pos.y+.45*size), vec2(.1*size, .5*size), point);
	res += rect(vec2(pos.x, pos.y+.45*size), vec2(size, .1*size), point);
	res += rect(pos, vec2(size, .1*size), point);
	res += rect(vec2(pos.x+.9*size, pos.y), vec2(.1*size, .5*size), point);
	res += rect(vec2(pos.x, pos.y), vec2(.1*size, .5*size), point);
	
	return max(.0,res);
}

float dig7(vec2 pos, float size, vec2 point)
{
	float res = 0.;
	
	res += rect(vec2(pos.x+.9*size, pos.y), vec2(.1*size, size), point);
	res += rect(vec2(pos.x, pos.y+.9*size), vec2(size, .1*size), point);
	
	return max(.0,res);
}

float dig8(vec2 pos, float size, vec2 point)
{
	float res = 0.;
	
	res += rect(vec2(pos.x, pos.y+.9*size), vec2(size, .1*size), point);
	res += rect(vec2(pos.x, pos.y+.45*size), vec2(size, .1*size), point);
	res += rect(pos, vec2(size, .1*size), point);
	res += rect(vec2(pos.x+.9*size, pos.y), vec2(.1*size, size), point);
	res += rect(pos, vec2(.1*size, size), point);
	
	return max(.0,res);
}

float dig9(vec2 pos, float size, vec2 point)
{
	float res = 0.;
	
	res += rect(vec2(pos.x, pos.y+.9*size), vec2(size, .1*size), point);
	res += rect(vec2(pos.x, pos.y+.45*size), vec2(size, .1*size), point);
	res += rect(pos, vec2(size, .1*size), point);
	res += rect(vec2(pos.x+.9*size, pos.y), vec2(.1*size, size), point);
	res += rect(vec2(pos.x, pos.y+.45*size), vec2(.1*size, .5*size), point);
	
	return max(.0,res);
}

float dig0(vec2 pos, float size, vec2 point)
{
	float res = 0.;
	
	res += rect(vec2(pos.x, pos.y+.9*size), vec2(size, .1*size), point);
	res += rect(pos, vec2(size, .1*size), point);
	res += rect(vec2(pos.x+.9*size, pos.y), vec2(.1*size, size), point);
	res += rect(pos, vec2(.1*size, size), point);
	
	return max(.0,res);
}

float number(vec2 pos, float size, vec2 point, float num)
{
	float res = 0.;
	float n = num;
	for (float i=0.; i < 4.; i++)
	{
		float digit = mod(n, 10.);
		
		if (digit == 1.0) res += dig1(vec2(pos.x - size*i*1.1, pos.y), size, point);
		if (digit == 2.0) res += dig2(vec2(pos.x - size*i*1.1, pos.y), size, point);
		if (digit == 3.0) res += dig3(vec2(pos.x - size*i*1.1, pos.y), size, point);
		if (digit == 4.0) res += dig4(vec2(pos.x - size*i*1.1, pos.y), size, point);
		if (digit == 5.0) res += dig5(vec2(pos.x - size*i*1.1, pos.y), size, point);
		if (digit == 6.0) res += dig6(vec2(pos.x - size*i*1.1, pos.y), size, point);
		if (digit == 7.0) res += dig7(vec2(pos.x - size*i*1.1, pos.y), size, point);
		if (digit == 8.0) res += dig8(vec2(pos.x - size*i*1.1, pos.y), size, point);
		if (digit == 9.0) res += dig9(vec2(pos.x - size*i*1.1, pos.y), size, point);
		if (digit == 0.0) res += dig0(vec2(pos.x - size*i*1.1, pos.y), size, point);
		
		n = floor(n/10.);
		if (n < 1.) break;
	}
	return res;
}

float player()
{
	return circle(vec2(xPos, mouse.y), 0.01, uv);
	//return rect(mouse, vec2(.04, .04), uv);
}

float playerPx()
{
	if (uv == vec2(xPos, mouse.y)) return 1.;
	else return 0.;
}

float path()
{
	if (last.a > 0.0) return 1.0;
	else return 0.;
}

float follower()
{
	if (uv.x < xPos && last.a > 0.0) return xPos - uv.x;
	else return 0.;
}

float gameOver()
{
	return 1.;
}

void setStage()
{
	if (time < 10.0) { stage = 0; stageTime = time; }
	else if (time == 10.0) { stage = 1; stageTime = 10.0; }
	else if (time < 20.0) { stage = 2; stageTime = time - 10.0; }
	else if (time < 40.0) { stage = 3; stageTime = time - 20.; }
	else if (time < 41.0) { stage = 4; stageTime = time - 30.; }
	else { stage = 5; }
}

vec2 rot(vec2 vec, float angle)
{
	float sn = sin(angle);
	float cs = cos(angle);
	
	return vec2(vec.x*cs - vec.y*sn, vec.x*sn + vec.y*cs);
}

void main( void ) {
	setStage();
	xPos = stageTime * 0.1;
	
	uv = gl_FragCoord.xy / resolution.xy;
	last = texture2D(backbuffer, uv);
	
	float r = rand(uv * time);
	vec3 me = vec3(1., 1., 1.);
	me -= vec3(r*.1,r*.1,r*.1);
	float meData = last.a;
	
	if (stage == 0)
	{	
		if (player() > 0.) { me = playerColor; meData = 0.5; }
		else
		{
			//float d = length(uv - vec2(xPos, mouse.y));
			//me *= vec3(d*.5, d*.5, d);
		}
	
	}
	else if (stage == 1)
	{
		me = vec3(1.0, 0.0, 0.0);
	}
	else if (stage == 2)
	{
		//if (follower() > 0.) me -= pathColor;
		me -= vec3(follower()*1., follower()*1.*rand(uv), .0);
	}
	else if (stage == 3)
	{	
		if (circle(vec2(mouse.x, 1.), 0.002, uv) > 0. && mod(floor(time), 1.) == 0.) { me = vec3(0., 1., 0.); meData =.1; }
		
		
		vec2 cu = vec2(uv.x, uv.y + 0.01);
		vec4 u = texture2D(backbuffer, cu);
		if (u.a > 0.5) { me = vec3(uv.x*sin(time*10.), r*cos(time*3.), r), meData = 1.0; }
	
		if (last.a < .2 && last.a > .05) 
		{ 
			me = last.rgb; meData = last.a; 
		}
		
		
		if (u.a < .2 && u.a > 0.05)
		{
			if (last.a > 0.5)
			{ 
				me = vec3(1., 1., 0.); meData = .3;
			}
			else if (last.a > .25 && last.a < .35)
			{
				me = vec3(1., 1., 1.); meData = .0;
			}
			else 
			{
				me = vec3(cos(time)+mod(time,2.), r*mod(time, 2.), mod(time, 2.)); meData = .1;
			}
		} 
		
		if (mod(floor(time), 4.) == 0. && last.a < 0.2 && last.a > 0.05) meData = 0.;
	}
	else if (stage == 4)
	{
		if (last.a > 0.5) { me = vec3(uv.x*sin(time*10.), r*cos(time*3.), r), meData = 1.0; }

		vec4 l = texture2D(backbuffer, vec2(uv.x - 0.01, uv.y));
		vec4 r = texture2D(backbuffer, vec2(uv.x + 0.01, uv.y));
		vec4 lu = texture2D(backbuffer, vec2(uv.x - 0.01, uv.y + 0.01));
		vec4 ru = texture2D(backbuffer, vec2(uv.x + 0.01, uv.y + 0.01)); 
		
		if ((lu.a < 0.01 && r.a < 0.01) || (ru.a < 0.01 && r.a < 0.01)) meData = 0.;
			
	}
	else
	{
		if (last.a > 0.5) { me = vec3(uv.x*sin(time*10.), r*cos(time*3.), r), meData = 1.0; }

		vec4 l = texture2D(backbuffer, vec2(uv.x - 0.01, uv.y));
		vec4 r = texture2D(backbuffer, vec2(uv.x + 0.01, uv.y));
		vec4 lu = texture2D(backbuffer, vec2(uv.x - 0.01, uv.y + 0.01));
		vec4 ru = texture2D(backbuffer, vec2(uv.x + 0.01, uv.y + 0.01)); 
		
		if (lu.a < 0.01) meData = 0.;
		
		float angle = sin(time)*.05;
		
		
		me = vec3(-.5,-.5,-.5);
		me += vec3(sin(time*100.), r*cos(time*100.));
		
		me -= rect(rot(vec2(0.3, 0.3), angle), vec2(0.005, 0.4), uv);
		me -= rect(rot(vec2(0.7, 0.3), angle), vec2(0.005, 0.4), uv);
		me -= rect(rot(vec2(0.3, 0.3), angle), vec2(0.4, 0.005), uv);
		me -= rect(rot(vec2(0.3, 0.7), angle), vec2(0.4, 0.005), uv);
		
		me -= rect(rot(vec2(0.4, 0.35), angle), vec2(0.005, 0.3), uv);
		me -= rect(rot(vec2(0.5, 0.35), angle), vec2(0.005, 0.3), uv);
		me -= rect(rot(vec2(0.6, 0.35), angle), vec2(0.005, 0.3), uv);
		me -= rect(rot(vec2(0.4, 0.5), angle), vec2(0.2, 0.005), uv);
		
	}
	
	//me -= number (vec2(0.15, 0.8), .04, uv, floor(time));
	//me -= number (vec2(0.9, 0.8), .04, uv, floor(stageTime));
	//me -= rect(vec2(xPos, 0.1), vec2(0.01, 0.04), uv);
	
	gl_FragColor = vec4( me, meData);
	//gl_FragColor = last;

}