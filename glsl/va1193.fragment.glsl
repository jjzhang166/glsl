#ifdef GL_ES
precision highp float;
#endif
struct mp
{
vec4 ambient;  
vec4 specular;
vec4 diffuse;
float shininess;
};
struct sphere {
  float radius;
  vec3 centre;
  mp Smp;
};
struct cylinder {
  float radius;
  vec3 centre;
  mp Cmp;
};
struct plane {
  vec3 normal;
  vec4 eq;
  mp Pmp;
};  

uniform float time;
plane plane1,plane2;
sphere sphere1,sphere2,sphere3,sphere4,sphere5,sphere6,sphere7;
cylinder cylinder1;
vec4 lmodel_ambient = vec4( 0.2, 0.2, 0.2, 1.0 );
vec4 specular = vec4( 0.3, 0.3, 0.3, 1.0 );
vec4 ambient = vec4( 0.8, 0.5, 0.1, 1.0 );
vec4 diffuse = vec4( .5, 0.5, 0.5, 1.0 );
//joij
vec3 lPos = vec3( 10.0, 50.0, 5.0 );
vec3 ro;
int checkSphere(in vec3 ro,in vec3 rd,in vec3 centre, in float radius,out float t)
{
	float b = 2.0 *( ( rd.x * (ro.x - centre.x ) )+  ( rd.y * (ro.y - centre.y )) + ( rd.z * (ro.z - centre.z ) ));
	float c = pow((ro.x - centre.x),2.0) + pow((ro.y - centre.y),2.0) + pow((ro.z - centre.z),2.0) - pow(radius,2.0);
	
	float det = b*b - 4.0*c ;
	
	if(det>0.0)
	{
		t= (-b - pow(det, .5)) / 2.0;
		if (t > 0.0)
		{
		        return 1;  
			 
		}
		else
			return 0;
		
	}
	else 
		return 0;
}
int checkPlane(vec3 ro, vec3 rd, out float t,in vec4 equation,in vec3 normal)
{
	float b = dot(normal, rd );
	if(b <= 0.0) 
	{
         	float a = - dot(ro,normal) - equation.w;
          	t = a/b ;
          	if(t >= 0.0) 
         		return  1;
          	else 
                  	return 0;
	}
	else
        {
          	t= 0.0;
		return 0; 
        }
}
int checkCylinder(in vec3 ro, in vec3 rd,in vec3 centre,in float radius, out float t )
{
   
    vec3  d = ro - centre;
    float a = dot(rd.xz,rd.xz);
    float b = dot(rd.xz,d.xz);
    float c = dot(d.xz,d.xz) - radius*radius;
    t = b*b - a*c;
    if( t > 0.0 )
    {
        t = (-b-sqrt(t)*sign(radius))/a;
        return 1;
    }
    return 0;
}
float calcShadow(in vec3 ro,in vec3 rd)
{
//nbbkj
 float factor = 1.0;
 float t1=0.0;
 rd=normalize(rd);
 if(checkSphere(ro,rd,sphere1.centre, sphere1.radius,t1) == 1 )
 {
  factor+=30.0;
 }
  if(checkSphere(ro,rd,sphere2.centre, sphere2.radius,t1) == 1 )
 {
  factor+=30.0;
 }
 if(checkPlane(ro,rd, t1,plane1.eq,plane1.normal) == 1)
 {
   factor+=0.0;
 }
if(checkPlane(ro,rd, t1,plane2.eq,plane2.normal) == 1)
 {
   factor+=0.0;
 }

	if(checkSphere(ro,rd,sphere3.centre, sphere3.radius,t1) == 1 )
 {
  factor+=30.0;
 }
 if(checkSphere(ro,rd,sphere4.centre, sphere4.radius,t1) == 1 )
 {
  factor+=30.0;
 }
	if(checkSphere(ro,rd,sphere5.centre, sphere5.radius,t1) == 1 )
 {
  factor+=30.0;
 }
if(checkSphere(ro,rd,sphere6.centre, sphere6.radius,t1) == 1 )
 {
  factor+=30.0;
 }
	//return .5;
 return (1.0/factor);//nkkn
}

vec3 calculateLight(in vec3 iro, in vec3 Normal, in vec4 mat_ambient, in vec4 mat_diffuse,in vec4  mat_specular, in float shininess)
{
	vec3 normal,lightDir,halfVector;
	vec3 n,halfV,viewV,ldir;
	float NdotL,NdotHV;
	vec4 diffuse1, ambient1;
	
	lightDir = normalize(lPos- iro);
	
	viewV = normalize (ro - iro);
	halfVector = normalize(lightDir + viewV);
	 
       
	/* Compute the diffuse, ambient and globalAmbient terms */
	diffuse1 = mat_diffuse* diffuse ;
	ambient1 = mat_ambient *ambient;
	ambient1 += lmodel_ambient * mat_ambient;
	
	float sf = calcShadow (iro,lPos);
	//sf=1.0;
	
	//if(sf<1.0)//
	//sf=0.0;
	diffuse1=sf*diffuse1;
	//diffuse1=vec4(0.0);
	/* a fragment shader can't write a verying variable, hence we need
	a new variable to store the normalized interpolated normal */
	n = normalize(Normal);
	
	vec4 color = ambient1;
	
	/* compute the dot product between normal and ldir */
	NdotL = max(dot(n,lightDir),0.0);

	if (NdotL > 0.0) {
	//	halfV = normalize(halfVector);
		NdotHV = max(dot(n,halfVector),0.0);
		color += mat_specular * specular * pow(NdotHV,shininess)*sf;
		color += diffuse1 * NdotL;
	}
	return color.rgb;
}

void getNormals(in vec3 ro,in int id,out vec3 normal)
{
	if(id==1)
	{
		normal=(ro - sphere1.centre)/sphere1.radius;
	}
	if(id==3)
	{
		normal=(ro - sphere2.centre)/sphere2.radius;
	}
	if(id==2)
	{
		normal=plane1.normal;	
	}
	if(id==4)
	{
		normal=plane2.normal;	
	}
	if(id==5)
	{
		normal=(ro - sphere3.centre)/sphere3.radius;
		//normal.xz = ro.xz-cylinder1.centre.xz;
        	//normal.y = 0.0;
        	//normal = normal/cylinder1.radius;
		//normal=(ro - cylinder1.centre)/cylinder1.radius;
	}
	if(id==6)
	{
		normal=(ro - sphere4.centre)/sphere4.radius;
	}
	if(id==7)
	{
		normal=(ro - sphere5.centre)/sphere5.radius;
	}
	if(id==8)
	{
		normal=(ro - sphere6.centre)/sphere6.radius;
	}
	
}
vec3 lighting(in vec3 iro,in vec3 normal,in int id)
{
	vec3 color;
	if(id==1)
	color=calculateLight(iro,normal,sphere1.Smp.ambient,sphere1.Smp.diffuse,sphere1.Smp.specular,sphere1.Smp.shininess);
	if(id==2)
	color=calculateLight(iro,normal,plane1.Pmp.ambient,plane1.Pmp.diffuse,plane1.Pmp.specular,plane1.Pmp.shininess);
	if(id==3)
	color=color=calculateLight(iro,normal,sphere2.Smp.ambient,sphere2.Smp.diffuse,sphere2.Smp.specular,sphere2.Smp.shininess);
	if(id==4)
	color=calculateLight(iro,normal,plane2.Pmp.ambient,plane2.Pmp.diffuse,plane2.Pmp.specular,plane2.Pmp.shininess);
	if(id==5)
	color=calculateLight(iro,normal,sphere3.Smp.ambient,sphere3.Smp.diffuse,sphere3.Smp.specular,sphere3.Smp.shininess);
	if(id==6)
	color=calculateLight(iro,normal,sphere4.Smp.ambient,sphere4.Smp.diffuse,sphere4.Smp.specular,sphere4.Smp.shininess);
	if(id==7)
	color=calculateLight(iro,normal,sphere5.Smp.ambient,sphere5.Smp.diffuse,sphere5.Smp.specular,sphere5.Smp.shininess);
	if(id==8)
	color=calculateLight(iro,normal,sphere6.Smp.ambient,sphere6.Smp.diffuse,sphere6.Smp.specular,sphere6.Smp.shininess);
	
	return color;
}

void checkintersection(in vec3 ro,in vec3 rd,out int id,out float tcal)
{
	
	float t=0.0;
	float tmin=1000.0;
	int check=0;
	check = checkSphere ( ro, rd, sphere1.centre, sphere1.radius ,t);
	id=0;
	if(check==1)
	{
		id=1;
		tmin=t;
	}
	check = checkSphere ( ro, rd, sphere2.centre, sphere2.radius ,t);
	//int check1 = checkPlane ( ro, rd, t1);
	if(check==1 && t<tmin)
	{
	tmin=t;
	id=3;
	}
	check = checkPlane (ro,rd, t,plane1.eq,plane1.normal);
	if(check==1 && t<tmin)
	{
	tmin=t;
	id=2;
	}
	check = checkPlane (ro,rd, t,plane2.eq,plane2.normal);
	if(check==1 && t<tmin)
	{
	tmin=t;
	id=4;
	}
	check = checkSphere (ro, rd, sphere3.centre, sphere3.radius ,t);
	if(check==1 && t<tmin)
	{
	tmin=t;
	id=5;
	}
	check = checkSphere (ro, rd, sphere4.centre, sphere4.radius ,t);
	if(check==1 && t<tmin)
	{
	tmin=t;
	id=6;
	}
	check = checkSphere (ro, rd, sphere5.centre, sphere5.radius ,t);
	if(check==1 && t<tmin)
	{
	tmin=t;
	id=7;
	}
	check = checkSphere (ro, rd, sphere6.centre, sphere6.radius ,t);
	if(check==1 && t<tmin)
	{
	tmin=t;
	id=8;
	}
	tcal=tmin;	

		
}
void main( void ) {
	plane1.normal=vec3(0.0,0.0,1.0);
	plane1.eq=vec4(0.0,0.0,1.0,20.0);
	plane1.Pmp.ambient = vec4 (0.2,0.0,0.0,1.0);
  	plane1.Pmp.diffuse = vec4 (0.8,0.8,.8,1.0);
  	plane1.Pmp.specular = vec4 (0.5,0.5,0.5,1.0);
  	plane1.Pmp.shininess = 5.0;
	// kn
	plane2.normal=vec3(0.0,1.0,0.0);
	plane2.eq=vec4(0.0,1.0,0.0,15.0);
	plane2.Pmp.ambient = vec4 (0.3,0.3,.3,1.0);
  	plane2.Pmp.diffuse = vec4 (1.0,1.0,1.0,1.0);
  	plane2.Pmp.specular = vec4 (1.0,1.0,1.0,1.0);
  	plane2.Pmp.shininess = 75.0;
	
	
	
	sphere1.centre=vec3 ((20.0 *sin(time))+10.0,0.0, (20.0 *cos (time)));
	sphere1.radius=10.0;
	sphere1.Smp.ambient = vec4 (0.7,0.7,.7,1.0);
  	sphere1.Smp.diffuse = vec4 (0.7,0.7,.7,1.0);
  	sphere1.Smp.specular = vec4 (1.0,1.0,1.0,1.0);
  	sphere1.Smp.shininess = 75.0;

	sphere2.centre=vec3 (20.0 *sin(time)+10.0,22.0, -20.0*cos (time));
	sphere2.radius=10.0;
	sphere2.Smp.ambient = vec4 (0.5,0.0,0.5,1.0);
  	sphere2.Smp.diffuse = vec4 (0.5,0.0,0.5,1.0);
  	sphere2.Smp.specular = vec4 (1.0,1.0,1.0,1.0);
  	sphere2.Smp.shininess = 75.0;
	//mopm
	sphere3.centre=vec3 (-24.0,0.0, 20.0);
	sphere3.radius=10.0;
	sphere3.Smp.ambient = vec4 (0.0,0.0,.5,1.0);
  	sphere3.Smp.diffuse = vec4 (0.0,0.0,0.7,1.0);
  	sphere3.Smp.specular = vec4 (1.0,1.0,1.0,1.0);
  	sphere3.Smp.shininess = 75.0;
	
	sphere4.centre=vec3 (44.0,0.0, 20.0);
	sphere4.radius=10.0;
	sphere4.Smp.ambient = vec4 (0.3,0.0,0.0,1.0);
  	sphere4.Smp.diffuse = vec4 (0.7,0.0,0.0,1.0);
  	sphere4.Smp.specular = vec4 (1.0,1.0,1.0,1.0);
  	sphere4.Smp.shininess = 75.0;
	
	sphere5.centre=vec3 (-24.0,22.0, 20.0);
	sphere5.radius=10.0;
	sphere5.Smp.ambient = vec4 (0.0,0.4,1.0,1.0);
  	sphere5.Smp.diffuse = vec4 (0.0,0.4,1.0,1.0);
  	sphere5.Smp.specular = vec4 (1.0,1.0,1.0,1.0);
  	sphere5.Smp.shininess = 75.0;
	
	sphere6.centre=vec3 (44.0,22.0, 20.0);
	sphere6.radius=10.0;
	sphere6.Smp.ambient = vec4 (0.0,0.3,0.0,1.0);
  	sphere6.Smp.diffuse = vec4 (0.0,0.7,0.0,1.0);
  	sphere6.Smp.specular = vec4 (1.0,1.0,1.0,1.0);
  	sphere6.Smp.shininess = 75.0;
	//jkkk
	vec2 position = -1.0 + ( gl_FragCoord.xy / 500.0)*2.0 ;	
	vec3 col=vec3(0.0);
	ro=vec3(0.0,10.0,85.0);
	vec3 rd = normalize( vec3(position, -1.0));
	int id=0,id2=0,id3=0,id4=0;
	float t=0.0,t1=0.0;
	checkintersection(ro,rd,id,t);
	
	vec3 iro;
	vec3 color;
	if(id>0)
	{
		iro.xyz = ro.xyz+ rd.xyz*t;
		vec3 normal=vec3(0.0);
		getNormals(iro,id,normal);
		normal=normalize(normal);
		color=lighting(iro,normal,id);
		gl_FragColor = vec4(color,1.0);
		//calculating reflection vector and color; iteration since recursion is not supported
         vec3 refColor; 
         vec3 reflected =reflect (rd,normal);
	vec3 reflectednormal;
         t1=0.0; 
         
         checkintersection(iro, reflected,id2,t1);    
         if( id2>0 )
         {
         refColor= vec3(1.0,1.0,1.0);
	 iro.xyz= iro.xyz + reflected.xyz*t1;
	getNormals(iro,id2,reflectednormal);
	          
         refColor = lighting(iro,reflectednormal,id2);
         gl_FragColor = vec4(mix(gl_FragColor.rgb, refColor,.40) ,1.0); 
		
	}
	//vsfsdrf
	vec3 reflected2 =reflect (reflected,reflectednormal);
	t1=0.0;
	checkintersection(iro,reflected2,id3,t1);
	if(id3>0)
	{
	refColor= vec3(1.0,1.0,1.0);
	iro.xyz= iro.xyz + reflected2.xyz*t1;
	getNormals(iro,id3,reflectednormal);
	          
         refColor = lighting(iro,reflectednormal,id3);
         gl_FragColor = vec4(mix(gl_FragColor.rgb, refColor,.60) ,1.0);	
	}
		
	vec3 reflected3 =reflect (reflected2,reflectednormal);
	t1=0.0;
	checkintersection(iro,reflected3,id4,t1);
	if(id3>0)
	{
	refColor= vec3(1.0,1.0,1.0);
	iro.xyz= iro.xyz + reflected3.xyz*t1;
	getNormals(iro,id4,reflectednormal);
	          
         refColor = lighting(iro,reflectednormal,id4);
         gl_FragColor = vec4(mix(gl_FragColor.rgb, refColor,.60) ,1.0);	
	}
	
		
		
}
	else
		discard;
}