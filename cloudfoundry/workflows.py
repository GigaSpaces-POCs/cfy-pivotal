import requests

from cloudify.decorators import workflow
from cloudify.workflows import ctx
from cloudify.exceptions import NonRecoverableError

endpoint = 'https://api.foo.com'  # TODO
token = ''  # TODO

DEPLOYMENT_TYPE = 'cloudify.cloudfoundry.deployment'


@workflow
def scale(node_instance_ids, node_ids, delta, **kwargs):
    to_scale = __nodes_to_scale(node_instance_ids, node_ids)
    num = len(to_scale)

    msg = '>>> Scaling %s nodes with delta = %d. <<<'.format(num, delta)
    ctx.logger.info(msg)

    for n in to_scale:
        __scale_one(n, delta)

    ctx.logger.info(__done_msg(num))

    pass


def __done_msg(num):
    n = 'node'
    if num > 1:
        n += 's'
    return '>>> Done scaling %s %s. <<<'.format(num, n)


def __ensure_node_type(node_type):
    error_msg = 'XXX Node type %s is not supported by this scale command. ' \
                'Only "%ss" can be scaled. XXX' \
        .format(node_type, DEPLOYMENT_TYPE)
    if node_type != DEPLOYMENT_TYPE:
        ctx.logger.warn(error_msg)
        return False
    return True


def __scale_one(node, delta):

    props = node.runtime_properties
    node_type = props['type']
    if not __ensure_node_type(node_type):
        return

    info_msg = '  > Scaling node [%s] with id [%s]. <' \
        .format(props['node_id'], props['id'])
    ctx.logger.info(info_msg)

    app_name = props['node_id']
    guid = __get_guid(app_name)
    if not guid:
        return

    app_info = _json_for('apps/%s'.format(guid))
    current = app_info['instances']
    final = current + delta

    info_msg = '  > Node [%s] is starting with %d instances. ' \
               'Will scale to %d instances. <'.format(guid, current, final)
    ctx.logger.info(info_msg)

    __do_scale(guid, final)

    return


def __headers():
    return {'': token}


def __do_scale(guid, final):
    payload = {'instances': final}
    url = endpoint + '/v2/%s'.format(guid)
    r = requests.put(url, headers=__headers(), payload=payload)
    c = r.code
    if c < 200 or c > 299:
        msg = 'Error updating node with guid [%s]'.format(guid)
        raise NonRecoverableError(msg)

    msg = '  > Done scaling node [%s] to %d instances. <'.format(guid, final)
    ctx.logger.info(msg)

    pass


def _json_for(url):
    r = requests.get(endpoint + '/v2/%s'.format(url), headers=__headers())
    return r.json()


def __get_guid(node):
    j = _json_for('apps')
    if j:
        results = j['resources']
        for result in results:
            (meta, name) = result['metadata'], result['entity']['name']
            if name == node['id']:
                return meta['guid']
    return None


def __nodes_to_scale(node_instance_ids, node_ids):
    all_instances = __get_all_nodes_instances()
    nodes = set()

    func1 = lambda i: i.runtime_properties['id'] in node_instance_ids
    nodes.add(filter(func1, all_instances))

    func2 = lambda j: j.runtime_properties['node_id'] in node_ids
    nodes.add(filter(func2, all_instances))

    return nodes


def __get_all_nodes_instances():
    node_instances = set()
    for node in ctx.nodes:
        for instance in node.instances:
            node_instances.add(instance)
    return node_instances
