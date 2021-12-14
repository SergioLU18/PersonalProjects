using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class generaRobots : MonoBehaviour
{
    public GameObject PrefabRobot;
    public GameObject PrefabCaja;
    public GameObject PrefabRobotCaja;
    public int numRobots;
    public int numCajas;
    List<GameObject> ArrRobots;
    List<GameObject> ArrCajas;
    List<GameObject> ArrPrefabRobotCaja;
    List<bool> obtainedBox;

    void Start()
    {

        ArrRobots = new List<GameObject>();
        ArrCajas = new List<GameObject>();
        ArrPrefabRobotCaja = new List<GameObject>();
        obtainedBox = new List<bool>();

        for(int i = 0; i < numRobots; i++) {
            
            float x = Random.Range(-10, 10);
            float y = 1.7f;
            float z = Random.Range(-10, 10);

            ArrRobots.Add(Instantiate(PrefabRobot, new Vector3(x, y, z), Quaternion.Euler(0,0,0)));
            ArrPrefabRobotCaja.Add(Instantiate(PrefabRobotCaja, new Vector3(0,0,0), Quaternion.Euler(0,0,0)));
            ArrPrefabRobotCaja[i].SetActive(false);
            obtainedBox.Add(false);

        }

        for(int i = 0; i < numCajas; i++) {
            
            float x = Random.Range(15, 20);
            float y = 0.8f;
            float z = Random.Range(-15, 15);

            ArrCajas.Add(Instantiate(PrefabCaja, new Vector3(x, y, z), Quaternion.Euler(0,0,0)));

        }


    }

    void moveRobot() {
        for(int i = 0; i < numRobots; i++) {
            Vector3 robot = ArrRobots[i].transform.position;
            Vector3 caja = ArrCajas[i].transform.position;
            caja.y = robot.y;


            if(obtainedBox[i] == false) {
                ArrRobots[i].transform.position = Vector3.MoveTowards(robot, caja, 0.15f);
                ArrRobots[i].transform.LookAt(caja);
                float dist = Mathf.Sqrt((robot.x - caja.x)*(robot.x - caja.x) + (robot.z - caja.z)*(robot.z - caja.z));
                if(dist < 4.0f) {
                    obtainedBox[i] = true;
                    ArrRobots[i].SetActive(false);
                    ArrCajas[i].SetActive(false);
                    ArrPrefabRobotCaja[i].transform.position = ArrRobots[i].transform.position;
                    ArrPrefabRobotCaja[i].SetActive(true);
                }
            }
            else {
                Vector3 estante = GameObject.FindWithTag("Estante").transform.position;
                Vector3 robotBox = ArrPrefabRobotCaja[i].transform.position;
                estante.y = robotBox.y;
                ArrPrefabRobotCaja[i].transform.position = Vector3.MoveTowards(robotBox, estante, 0.15f);
                ArrPrefabRobotCaja[i].transform.LookAt(estante);
                ArrPrefabRobotCaja[i].transform.Rotate(0.0f, -90.0f, 0.0f, Space.Self);
                float dist = Mathf.Sqrt((robotBox.x - estante.x)*(robotBox.x - estante.x) + (robotBox.z - estante.z)*(robotBox.z - estante.z));
                if(dist < 6.0f) {
                    // Explode
                    ArrPrefabRobotCaja[i].SetActive(false);
                }
            }

        }
    }

    void Update()
    {



        Debug.DrawLine(Vector3.zero, new Vector3(10, 0, 0), Color.red);
        Debug.DrawLine(Vector3.zero, new Vector3(0, 10, 0), Color.green);
        Debug.DrawLine(Vector3.zero, new Vector3(0, 0, 10), Color.blue);
        moveRobot();
    }   
}
