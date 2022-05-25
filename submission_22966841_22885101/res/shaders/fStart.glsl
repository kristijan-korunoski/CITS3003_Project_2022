// Kristijan Korunoski - 22966841
// Luke Kirkby - 22885101

varying vec2 texCoord;  // The third coordinate is always 0.0 and is discarded
// Task G
varying vec3 pos;
varying vec3 varN;

uniform sampler2D texture;
// Task C
uniform float texScale;


// Task G
// Task I & J
uniform vec3 AmbientProduct, DiffuseProduct, SpecularProduct;
uniform vec3 AmbientProduct2, DiffuseProduct2, SpecularProduct2;
uniform vec3 AmbientProduct3, DiffuseProduct3, SpecularProduct3;
uniform vec4 LightPosition, LightPosition2, LightPosition3;
uniform float Shininess;
//Task J
uniform float Light3CutOff;
uniform float L3pitch;
uniform float L3yaw;

void main()
{
    // Task G Light calculations moved to fragment shader
    // The vector to the light from the vertex    
    vec3 Lvec = LightPosition.xyz - pos;
    // Task I & J
    vec3 L2vec = LightPosition2.xyz; // Direction of light is to origin not position
    vec3 L3vec = LightPosition3.xyz - pos;

    // Task J
    vec3 L3direct; //Directional vector for light 3
    L3direct.x = cos(radians(L3yaw))*cos(radians(L3pitch));
    L3direct.y = sin(radians(L3pitch));
    L3direct.z = sin(radians(L3yaw))*cos(radians(L3pitch));

    // Task F
    float distance = sqrt(Lvec[0]*Lvec[0] + Lvec[1]*Lvec[1] + Lvec[2]*Lvec[2]);
    float scaleDist = 1.0/(distance*distance);

    // Task I & J
    // Unit direction vectors for Blinn-Phong shading calculation
    vec3 L = normalize( Lvec );   // Direction to the light source
    vec3 L2 = normalize( L2vec );  // Direction to light source
    vec3 L3 = normalize( L3vec );  // Direction to light source
    vec3 E = normalize( -pos );   // Direction to the eye/camera
    vec3 H = normalize( L + E );  // Halfway vector
    vec3 H2 = normalize( L2 + E );// Halfway vector for light 2

    // Transform vertex normal into eye coordinates (assumes scaling
    // is uniform across dimensions)
    vec3 N = normalize(varN);

    //Calculates if it is out of the spotlight
    // Task J
    float theta = dot(L3, normalize(L3direct));

    // Compute terms in the illumination equation
    // Task I & J
    vec3 ambient1 = AmbientProduct;
    vec3 ambient2 = AmbientProduct2;
    vec3 ambient3 = AmbientProduct3;

    // Diffuse
    // Task I & J
    float Kd = max( dot(L, N), 0.0 );
    float Kd2 = max( dot(L2, N), 0.0 );
    float Kd3 = max( theta, 0.0);
    vec3  diffuse1 = Kd * DiffuseProduct;
    vec3  diffuse2 = Kd2 * DiffuseProduct2;
    vec3  diffuse3 = Kd3 * DiffuseProduct3;

    // Specular
    // Task I & J
    float Ks = pow( max(dot(N, H), 0.0), Shininess );
    float Ks2 = pow( max(dot(N, H2), 0.0), Shininess );
    float Ks3 = pow( max(theta, 0.0), Shininess );
    vec3  specular1 = Ks * SpecularProduct;
    vec3  specular2 = Ks2 * SpecularProduct2;
    vec3  specular3 = Ks3 * SpecularProduct3;
    
    if (dot(L, N) < 0.0 ) {
	    specular1 = vec3(0.0, 0.0, 0.0);
    } 

    // Task I
    if (dot(L2, N) < 0.0 ) {
	     specular2 = vec3(0.0, 0.0, 0.0);
    } 

    // Task J
    if (theta < 0.0 ) {
	    specular3 = vec3(0.0, 0.0, 0.0);
    } 
    
    // globalAmbient is independent of distance from the light source
    vec3 globalAmbient = vec3(0.07, 0.07, 0.07);
    
    // Task F & G
    vec4 color;

    // Task J
    if(theta > Light3CutOff){
        color.rgb = globalAmbient + scaleDist*(ambient1 + diffuse1 + specular1) + (ambient2 + diffuse2 + specular2) + (ambient3 + diffuse3 + specular3);
        // Testing for Task H
        //color.rgb = globalAmbient + scaleDist*(specular1);
        color.a = 1.0;
    }
    else{
        // Task I & J
        color.rgb = globalAmbient + scaleDist*(ambient1 + diffuse1 + specular1) + (ambient2 + diffuse2 + specular2);
        color.a = 1.0;
    }

    // Task B texture movement
    gl_FragColor = color * texture2D( texture, texCoord * texScale );
}
